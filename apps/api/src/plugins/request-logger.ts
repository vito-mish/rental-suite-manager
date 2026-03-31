import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '@rental-suite/db';

export async function registerRequestLogger(app: FastifyInstance) {
  app.addHook('onResponse', async (request: FastifyRequest, reply: FastifyReply) => {
    // Fire-and-forget — don't slow down the response
    const responseTime = Math.round(reply.elapsedTime);
    const ip =
      (request.headers['x-forwarded-for'] as string)?.split(',')[0]?.trim() ||
      request.ip;

    prisma.requestLog
      .create({
        data: {
          method: request.method,
          url: request.url,
          statusCode: reply.statusCode,
          responseTime,
          ip,
          userAgent: request.headers['user-agent'] || null,
          userId: (request as any).userId || null,
        },
      })
      .catch((err) => {
        request.log.error(err, 'Failed to write request log');
      });
  });
}
