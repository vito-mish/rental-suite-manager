import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { authHook } from '../plugins/auth';
import {
  moveInSchema,
  updateLeaseSchema,
  listLeaseQuerySchema,
} from '../schemas/lease';

export default async function leaseRoutes(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);

  // Move-in: create lease + update property status (T-22)
  fastify.post('/leases/move-in', async (request, reply) => {
    const parsed = moveInSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { tenantId, propertyId, startDate, endDate, monthlyRent, deposit, terms } = parsed.data;

    // Verify property belongs to user and is vacant
    const property = await prisma.property.findFirst({
      where: { id: propertyId, userId: request.userId },
    });
    if (!property) {
      return reply.status(404).send({ error: '找不到此房源' });
    }
    if (property.status !== 'VACANT') {
      return reply.status(409).send({ error: '此房源目前非空房，無法入住' });
    }

    // Verify tenant belongs to user
    const tenant = await prisma.tenant.findFirst({
      where: { id: tenantId, userId: request.userId },
    });
    if (!tenant) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    // Check tenant doesn't have an active lease
    const activeLease = await prisma.lease.findFirst({
      where: { tenantId, status: 'ACTIVE' },
    });
    if (activeLease) {
      return reply.status(409).send({ error: '此租客已有進行中的租約' });
    }

    // Transaction: create lease + update property + update tenant
    const lease = await prisma.$transaction(async (tx) => {
      const newLease = await tx.lease.create({
        data: {
          propertyId,
          tenantId,
          startDate: new Date(startDate),
          endDate: new Date(endDate),
          monthlyRent,
          deposit,
          terms,
        },
        include: {
          property: { select: { id: true, name: true, roomNumber: true, floor: true } },
          tenant: { select: { id: true, name: true, phone: true } },
        },
      });

      await tx.property.update({
        where: { id: propertyId },
        data: { status: 'OCCUPIED' },
      });

      await tx.tenant.update({
        where: { id: tenantId },
        data: { moveInDate: new Date(startDate) },
      });

      // Auto-generate monthly payments for entire lease duration
      // Due dates align with lease start day (e.g. start 3/19 → due 3/19, 4/19, 5/19...)
      const start = new Date(startDate);
      const end = new Date(endDate);
      const payments = [];
      const startDay = start.getUTCDate();
      let curYear = start.getUTCFullYear();
      let curMonth = start.getUTCMonth();
      while (true) {
        const dueDate = new Date(Date.UTC(curYear, curMonth, startDay));
        if (dueDate >= end) break;
        payments.push({
          leaseId: newLease.id,
          amount: monthlyRent,
          dueDate,
          status: 'PENDING' as const,
        });
        curMonth++;
        if (curMonth >= 12) { curMonth = 0; curYear++; }
      }

      if (payments.length > 0) {
        await tx.payment.createMany({ data: payments });
      }

      return newLease;
    });

    return reply.status(201).send(lease);
  });

  // Move-out: terminate lease + update property status (T-22)
  fastify.post<{ Params: { id: string } }>('/leases/:id/move-out', async (request, reply) => {
    const lease = await prisma.lease.findFirst({
      where: { id: request.params.id, status: 'ACTIVE' },
      include: { property: true, tenant: true },
    });

    if (!lease) {
      return reply.status(404).send({ error: '找不到此進行中的租約' });
    }

    // Verify ownership via property
    if (lease.property.userId !== request.userId) {
      return reply.status(404).send({ error: '找不到此進行中的租約' });
    }

    const result = await prisma.$transaction(async (tx) => {
      const updated = await tx.lease.update({
        where: { id: request.params.id },
        data: { status: 'TERMINATED' },
        include: {
          property: { select: { id: true, name: true, roomNumber: true, floor: true } },
          tenant: { select: { id: true, name: true, phone: true } },
        },
      });

      await tx.property.update({
        where: { id: lease.propertyId },
        data: { status: 'VACANT' },
      });

      await tx.tenant.update({
        where: { id: lease.tenantId },
        data: { moveOutDate: new Date() },
      });

      return updated;
    });

    return reply.send(result);
  });

  // List leases (T-26)
  fastify.get('/leases', async (request, reply) => {
    const parsed = listLeaseQuerySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { status, search, propertyId, tenantId, sort, order, page, limit } = parsed.data;

    const where = {
      property: { userId: request.userId },
      ...(status && { status }),
      ...(propertyId && { propertyId }),
      ...(tenantId && { tenantId }),
      ...(search && {
        OR: [
          { tenant: { name: { contains: search, mode: 'insensitive' as const } } },
          { property: { roomNumber: { contains: search, mode: 'insensitive' as const } } },
        ],
      }),
    };

    const [data, total] = await Promise.all([
      prisma.lease.findMany({
        where,
        orderBy: { [sort]: order },
        skip: (page - 1) * limit,
        take: limit,
        include: {
          property: { select: { id: true, name: true, roomNumber: true, floor: true } },
          tenant: { select: { id: true, name: true, phone: true } },
        },
      }),
      prisma.lease.count({ where }),
    ]);

    return reply.send({ data, total, page, limit });
  });

  // Get lease detail (T-26)
  fastify.get<{ Params: { id: string } }>('/leases/:id', async (request, reply) => {
    const lease = await prisma.lease.findFirst({
      where: { id: request.params.id, property: { userId: request.userId } },
      include: {
        property: { select: { id: true, name: true, roomNumber: true, floor: true, area: true } },
        tenant: { select: { id: true, name: true, phone: true, email: true, idNumber: true } },
        payments: { orderBy: { dueDate: 'desc' } },
      },
    });

    if (!lease) {
      return reply.status(404).send({ error: '找不到此租約' });
    }

    return reply.send(lease);
  });

  // Update lease (T-26)
  fastify.put<{ Params: { id: string } }>('/leases/:id', async (request, reply) => {
    const parsed = updateLeaseSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const existing = await prisma.lease.findFirst({
      where: { id: request.params.id, property: { userId: request.userId } },
    });

    if (!existing) {
      return reply.status(404).send({ error: '找不到此租約' });
    }

    const { endDate, ...rest } = parsed.data;
    const data: Record<string, unknown> = { ...rest };
    if (endDate !== undefined) data.endDate = new Date(endDate);

    const updated = await prisma.lease.update({
      where: { id: request.params.id },
      data,
      include: {
        property: { select: { id: true, name: true, roomNumber: true, floor: true } },
        tenant: { select: { id: true, name: true, phone: true } },
      },
    });

    return reply.send(updated);
  });
}
