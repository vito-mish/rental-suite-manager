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

    const { status, floor, sort, order, page, limit } = parsed.data;

    const where = {
      userId: request.userId,
      ...(status && { status }),
      ...(floor !== undefined && { floor }),
    };

    const [data, total] = await Promise.all([
      prisma.property.findMany({
        where,
        orderBy: { [sort]: order },
        skip: (page - 1) * limit,
        take: limit,
      }),
      prisma.property.count({ where }),
    ]);

    return reply.send({ data, total, page, limit });
  });

  // Get property detail
  fastify.get<{ Params: { id: string } }>('/properties/:id', async (request, reply) => {
    const property = await prisma.property.findFirst({
      where: { id: request.params.id, userId: request.userId },
      include: {
        leases: {
          where: { status: 'ACTIVE' },
          include: { tenant: true },
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
