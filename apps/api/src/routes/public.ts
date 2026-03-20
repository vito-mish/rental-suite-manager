import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { z } from 'zod';

const querySchema = z.object({
  name: z.string().min(1).max(100),
  phone: z.string().min(1).max(20),
});

export default async function publicRoutes(fastify: FastifyInstance) {
  // Tenant self-service: query lease & payment records by name + phone
  fastify.get('/tenant-records', {
    config: {
      rateLimit: {
        max: 10,
        timeWindow: '1 minute',
      },
    },
  }, async (request, reply) => {
    const parsed = querySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: '請輸入姓名與電話' });
    }

    const { name, phone } = parsed.data;

    // Normalize phone: strip dashes/spaces for matching
    const phoneDigits = phone.replace(/[^0-9]/g, '');

    // Search all tenants matching name, then compare phone digits
    const candidates = await prisma.tenant.findMany({
      where: {
        name: { equals: name, mode: 'insensitive' },
      },
      select: { id: true, phone: true },
    });

    const matched = candidates.find(
      (t) => t.phone.replace(/[^0-9]/g, '') === phoneDigits
    );

    if (!matched) {
      return reply.status(404).send({ error: '查無資料，請確認姓名與電話是否正確' });
    }

    const tenant = await prisma.tenant.findFirst({
      where: { id: matched.id },
      select: {
        id: true,
        name: true,
        phone: true,
        leases: {
          select: {
            id: true,
            startDate: true,
            endDate: true,
            monthlyRent: true,
            deposit: true,
            status: true,
            property: {
              select: {
                floor: true,
                roomNumber: true,
              },
            },
            payments: {
              select: {
                id: true,
                amount: true,
                discount: true,
                dueDate: true,
                paidDate: true,
                status: true,
                method: true,
              },
              orderBy: { dueDate: 'desc' },
            },
          },
          orderBy: { startDate: 'desc' },
        },
      },
    });

    if (!tenant) {
      return reply.status(404).send({ error: '查無資料，請確認姓名與電話是否正確' });
    }

    return reply.send(tenant);
  });
}
