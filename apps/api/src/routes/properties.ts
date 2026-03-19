import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { authHook } from '../plugins/auth';
import {
  createPropertySchema,
  updatePropertySchema,
  listPropertyQuerySchema,
} from '../schemas/property';

export default async function propertyRoutes(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);

  // Create property
  fastify.post('/properties', async (request, reply) => {
    const parsed = createPropertySchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const property = await prisma.property.create({
      data: {
        ...parsed.data,
        userId: request.userId,
      },
    });

    return reply.status(201).send(property);
  });

  // List properties
  fastify.get('/properties', async (request, reply) => {
    const parsed = listPropertyQuerySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { status, search, floor, sort, order, page, limit } = parsed.data;

    const where = {
      userId: request.userId,
      ...(status && { status }),
      ...(floor !== undefined && { floor }),
      ...(search && {
        OR: [
          { roomNumber: { contains: search, mode: 'insensitive' as const } },
          { name: { contains: search, mode: 'insensitive' as const } },
          { leases: { some: { status: 'ACTIVE' as const, tenant: { name: { contains: search, mode: 'insensitive' as const } } } } },
        ],
      }),
    };

    const [data, total] = await Promise.all([
      prisma.property.findMany({
        where,
        orderBy: { [sort]: order },
        skip: (page - 1) * limit,
        take: limit,
        include: {
          leases: {
            where: { status: 'ACTIVE' },
            include: {
              tenant: { select: { id: true, name: true, phone: true } },
              payments: { select: { id: true, status: true, dueDate: true, amount: true, paidDate: true } },
            },
            take: 1,
          },
        },
      }),
      prisma.property.count({ where }),
    ]);

    // Compute validity for each property
    const enriched = data.map((p) => {
      const lease = p.leases[0];
      if (!lease) return { ...p, leases: undefined, activeLease: null };
      const paidCount = lease.payments.filter((pay) => pay.status === 'PAID').length;
      const start = new Date(lease.startDate);
      const validUntil = new Date(Date.UTC(start.getUTCFullYear(), start.getUTCMonth() + paidCount, start.getUTCDate() - 1));
      return {
        ...p,
        leases: undefined,
        activeLease: {
          id: lease.id,
          tenant: lease.tenant,
          startDate: lease.startDate,
          endDate: lease.endDate,
          monthlyRent: lease.monthlyRent,
          paidCount,
          totalPayments: lease.payments.length,
          validUntil,
        },
      };
    });

    return reply.send({ data: enriched, total, page, limit });
  });

  // Get property detail
  fastify.get<{ Params: { id: string } }>('/properties/:id', async (request, reply) => {
    const property = await prisma.property.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: {
        leases: {
          where: { status: 'ACTIVE' },
          include: {
            tenant: true,
            payments: { orderBy: { dueDate: 'asc' } },
          },
          take: 1,
        },
      },
    });

    if (!property) {
      return reply.status(404).send({ error: '找不到此房源' });
    }

    return reply.send(property);
  });

  // Update property
  fastify.put<{ Params: { id: string } }>('/properties/:id', async (request, reply) => {
    const parsed = updatePropertySchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const existing = await prisma.property.findFirst({
      where: { id: request.params.id, userId: request.userId },
    });

    if (!existing) {
      return reply.status(404).send({ error: '找不到此房源' });
    }

    const updated = await prisma.property.update({
      where: { id: request.params.id },
      data: parsed.data,
    });

    return reply.send(updated);
  });

  // Delete property
  fastify.delete<{ Params: { id: string } }>('/properties/:id', async (request, reply) => {
    const property = await prisma.property.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: { leases: { where: { status: 'ACTIVE' }, take: 1 } },
    });

    if (!property) {
      return reply.status(404).send({ error: '找不到此房源' });
    }

    if (property.leases.length > 0) {
      return reply.status(409).send({ error: '此房源有進行中的租約，無法刪除' });
    }

    await prisma.property.delete({ where: { id: request.params.id } });
    return reply.status(204).send();
  });

  // Archive property
  fastify.patch<{ Params: { id: string } }>('/properties/:id/archive', async (request, reply) => {
    const property = await prisma.property.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: { leases: { where: { status: 'ACTIVE' }, take: 1 } },
    });

    if (!property) {
      return reply.status(404).send({ error: '找不到此房源' });
    }

    if (property.leases.length > 0) {
      return reply.status(409).send({ error: '此房源有進行中的租約，無法封存' });
    }

    const updated = await prisma.property.update({
      where: { id: request.params.id },
      data: { status: 'ARCHIVED' },
    });

    return reply.send(updated);
  });
}
