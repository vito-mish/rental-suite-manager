import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { authHook } from '../plugins/auth';
import {
  createTenantSchema,
  updateTenantSchema,
  listTenantQuerySchema,
} from '../schemas/tenant';

export default async function tenantRoutes(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);

  // Create tenant
  fastify.post('/tenants', async (request, reply) => {
    const parsed = createTenantSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { email, idNumber, lineId, moveInDate, moveOutDate, emergencyContacts, ...rest } = parsed.data;

    const tenant = await prisma.tenant.create({
      data: {
        ...rest,
        email: email || null,
        idNumber: idNumber || null,
        lineId: lineId || null,
        moveInDate: moveInDate ? new Date(moveInDate) : null,
        moveOutDate: moveOutDate ? new Date(moveOutDate) : null,
        userId: request.userId,
        ...(emergencyContacts && emergencyContacts.length > 0 && {
          emergencyContacts: {
            create: emergencyContacts,
          },
        }),
      },
      include: { emergencyContacts: true },
    });

    return reply.status(201).send(tenant);
  });

  // List tenants with search
  fastify.get('/tenants', async (request, reply) => {
    const parsed = listTenantQuerySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { search, sort, order, page, limit } = parsed.data;

    const where = {
      userId: request.userId,
      ...(search && {
        OR: [
          { name: { contains: search, mode: 'insensitive' as const } },
          { phone: { contains: search } },
          { email: { contains: search, mode: 'insensitive' as const } },
        ],
      }),
    };

    const [data, total] = await Promise.all([
      prisma.tenant.findMany({
        where,
        orderBy: { [sort]: order },
        skip: (page - 1) * limit,
        take: limit,
        include: {
          leases: {
            where: { status: 'ACTIVE' },
            include: { property: { select: { id: true, name: true, roomNumber: true } } },
            take: 1,
          },
        },
      }),
      prisma.tenant.count({ where }),
    ]);

    return reply.send({ data, total, page, limit });
  });

  // Get tenant detail
  fastify.get<{ Params: { id: string } }>('/tenants/:id', async (request, reply) => {
    const tenant = await prisma.tenant.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: {
        leases: {
          include: {
            property: { select: { id: true, name: true, roomNumber: true, floor: true } },
          },
          orderBy: { startDate: 'desc' },
        },
        documents: { orderBy: { createdAt: 'desc' } },
        emergencyContacts: true,
      },
    });

    if (!tenant) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    return reply.send(tenant);
  });

  // Update tenant
  fastify.put<{ Params: { id: string } }>('/tenants/:id', async (request, reply) => {
    const parsed = updateTenantSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const existing = await prisma.tenant.findFirst({
      where: { id: request.params.id, userId: request.userId },
    });

    if (!existing) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    const { email, idNumber, lineId, moveInDate, moveOutDate, emergencyContacts, ...rest } = parsed.data;
    const data: Record<string, unknown> = { ...rest };
    if (email !== undefined) data.email = email || null;
    if (idNumber !== undefined) data.idNumber = idNumber || null;
    if (lineId !== undefined) data.lineId = lineId || null;
    if (moveInDate !== undefined) data.moveInDate = moveInDate ? new Date(moveInDate) : null;
    if (moveOutDate !== undefined) data.moveOutDate = moveOutDate ? new Date(moveOutDate) : null;

    if (emergencyContacts !== undefined) {
      data.emergencyContacts = {
        deleteMany: {},
        create: emergencyContacts,
      };
    }

    const updated = await prisma.tenant.update({
      where: { id: request.params.id },
      data,
      include: { emergencyContacts: true },
    });

    return reply.send(updated);
  });

  // Delete tenant
  fastify.delete<{ Params: { id: string } }>('/tenants/:id', async (request, reply) => {
    const tenant = await prisma.tenant.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: { leases: { where: { status: 'ACTIVE' }, take: 1 } },
    });

    if (!tenant) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    if (tenant.leases.length > 0) {
      return reply.status(409).send({ error: '此租客有進行中的租約，無法刪除' });
    }

    await prisma.tenant.delete({ where: { id: request.params.id } });
    return reply.status(204).send();
  });

  // Get tenant lease history (T-24)
  fastify.get<{ Params: { id: string } }>('/tenants/:id/history', async (request, reply) => {
    const tenant = await prisma.tenant.findFirst({
      where: { id: request.params.id, userId: request.userId },
    });

    if (!tenant) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    const leases = await prisma.lease.findMany({
      where: { tenantId: request.params.id },
      include: {
        property: { select: { id: true, name: true, roomNumber: true, floor: true } },
      },
      orderBy: { startDate: 'desc' },
    });

    return reply.send(leases);
  });

  // Add tenant document metadata (T-23)
  fastify.post<{ Params: { id: string } }>('/tenants/:id/documents', async (request, reply) => {
    const tenant = await prisma.tenant.findFirst({
      where: { id: request.params.id, userId: request.userId },
    });

    if (!tenant) {
      return reply.status(404).send({ error: '找不到此租客' });
    }

    const { type, name, url } = request.body as { type: string; name: string; url: string };
    if (!type || !name || !url) {
      return reply.status(400).send({ error: '缺少必要欄位: type, name, url' });
    }

    const doc = await prisma.tenantDocument.create({
      data: { tenantId: request.params.id, type, name, url },
    });

    return reply.status(201).send(doc);
  });

  // Delete tenant document (T-23)
  fastify.delete<{ Params: { id: string; docId: string } }>(
    '/tenants/:id/documents/:docId',
    async (request, reply) => {
      const tenant = await prisma.tenant.findFirst({
        where: { id: request.params.id, userId: request.userId },
      });

      if (!tenant) {
        return reply.status(404).send({ error: '找不到此租客' });
      }

      const doc = await prisma.tenantDocument.findFirst({
        where: { id: request.params.docId, tenantId: request.params.id },
      });

      if (!doc) {
        return reply.status(404).send({ error: '找不到此文件' });
      }

      await prisma.tenantDocument.delete({ where: { id: request.params.docId } });
      return reply.status(204).send();
    },
  );
}
