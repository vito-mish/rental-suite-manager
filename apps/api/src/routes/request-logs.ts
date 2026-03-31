import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { authHook } from '../plugins/auth';
import { z } from 'zod';

const querySchema = z.object({
  method: z.string().optional(),
  url: z.string().optional(),
  statusCode: z.coerce.number().int().optional(),
  excludeUrl: z.string().optional(),
  from: z.string().datetime({ offset: true }).optional(),
  to: z.string().datetime({ offset: true }).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(50),
});

export default async function requestLogRoutes(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);

  fastify.get('/request-logs', async (request, reply) => {
    const parsed = querySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { method, url, statusCode, excludeUrl, from, to, page, limit } = parsed.data;

    const where: any = {};
    if (method) where.method = method.toUpperCase();
    if (url) where.url = { contains: url };
    if (excludeUrl) where.NOT = { url: { contains: excludeUrl } };
    if (statusCode) where.statusCode = statusCode;
    if (from || to) {
      where.createdAt = {};
      if (from) where.createdAt.gte = new Date(from);
      if (to) where.createdAt.lte = new Date(to);
    }

    const [logs, total] = await Promise.all([
      prisma.requestLog.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      prisma.requestLog.count({ where }),
    ]);

    return reply.send({
      data: logs,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  });
}
