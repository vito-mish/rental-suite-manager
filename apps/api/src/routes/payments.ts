import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';
import { authHook } from '../plugins/auth';
import { markPaidSchema, listPaymentQuerySchema, batchPaySchema } from '../schemas/payment';

export default async function paymentRoutes(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);

  // Generate monthly payments for all active leases (T-31)
  fastify.post('/payments/generate', async (request, reply) => {
    const { month } = (request.body as { month?: string }) || {};

    // Default to current month
    const now = new Date();
    const targetYear = month ? parseInt(month.split('-')[0]) : now.getFullYear();
    const targetMonth = month ? parseInt(month.split('-')[1]) - 1 : now.getMonth();

    const dueDate = new Date(targetYear, targetMonth + 1, 1); // 1st of next month
    const monthStart = new Date(targetYear, targetMonth, 1);
    const monthEnd = new Date(targetYear, targetMonth + 1, 0, 23, 59, 59);

    // Find all active leases for this user
    const activeLeases = await prisma.lease.findMany({
      where: {
        status: 'ACTIVE',
        property: { userId: request.userId },
        startDate: { lte: monthEnd },
        endDate: { gte: monthStart },
      },
      include: { property: true },
    });

    let created = 0;
    let skipped = 0;

    for (const lease of activeLeases) {
      // Check if payment already exists for this lease + month
      const existing = await prisma.payment.findFirst({
        where: {
          leaseId: lease.id,
          dueDate: {
            gte: monthStart,
            lte: monthEnd,
          },
        },
      });

      if (existing) {
        skipped++;
        continue;
      }

      await prisma.payment.create({
        data: {
          leaseId: lease.id,
          amount: lease.monthlyRent,
          dueDate,
          status: 'PENDING',
        },
      });
      created++;
    }

    return reply.send({ created, skipped, total: activeLeases.length });
  });

  // List payments (T-32)
  fastify.get('/payments', async (request, reply) => {
    // Auto-mark overdue
    await prisma.payment.updateMany({
      where: {
        status: 'PENDING',
        dueDate: { lt: new Date() },
        lease: { property: { userId: request.userId } },
      },
      data: { status: 'OVERDUE' },
    });
    const parsed = listPaymentQuerySchema.safeParse(request.query);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { leaseId, status, search, month, sort, order, page, limit } = parsed.data;

    let dueDateFilter = {};
    if (month) {
      const [y, m] = month.split('-').map(Number);
      dueDateFilter = {
        dueDate: {
          gte: new Date(y, m - 1, 1),
          lte: new Date(y, m, 0, 23, 59, 59),
        },
      };
    }

    const where = {
      lease: {
        property: { userId: request.userId },
        ...(search && {
          OR: [
            { tenant: { name: { contains: search, mode: 'insensitive' as const } } },
            { property: { roomNumber: { contains: search, mode: 'insensitive' as const } } },
          ],
        }),
      },
      ...(leaseId && { leaseId }),
      ...(status && { status }),
      ...dueDateFilter,
    };

    const [data, total] = await Promise.all([
      prisma.payment.findMany({
        where,
        orderBy: { [sort]: order },
        skip: (page - 1) * limit,
        take: limit,
        include: {
          lease: {
            include: {
              property: { select: { id: true, name: true, roomNumber: true, floor: true } },
              tenant: { select: { id: true, name: true, phone: true } },
            },
          },
        },
      }),
      prisma.payment.count({ where }),
    ]);

    return reply.send({ data, total, page, limit });
  });

  // Mark payment as paid (T-32)
  fastify.patch<{ Params: { id: string } }>('/payments/:id/pay', async (request, reply) => {
    const parsed = markPaidSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const payment = await prisma.payment.findFirst({
      where: { id: request.params.id },
      include: { lease: { include: { property: true } } },
    });

    if (!payment || payment.lease.property.userId !== request.userId) {
      return reply.status(404).send({ error: '找不到此帳單' });
    }

    if (payment.status === 'PAID') {
      return reply.status(409).send({ error: '此帳單已繳費' });
    }

    const updated = await prisma.payment.update({
      where: { id: request.params.id },
      data: {
        status: 'PAID',
        paidDate: new Date(),
        method: parsed.data.method,
        receipt: parsed.data.receipt,
      },
      include: {
        lease: {
          include: {
            property: { select: { id: true, name: true, roomNumber: true, floor: true } },
            tenant: { select: { id: true, name: true, phone: true } },
          },
        },
      },
    });

    return reply.send(updated);
  });

  // Monthly income report (T-34)
  fastify.get('/payments/report', async (request, reply) => {
    const { month } = request.query as { month?: string };

    const now = new Date();
    const targetYear = month ? parseInt(month.split('-')[0]) : now.getFullYear();
    const targetMonth = month ? parseInt(month.split('-')[1]) - 1 : now.getMonth();

    const monthStart = new Date(targetYear, targetMonth, 1);
    const monthEnd = new Date(targetYear, targetMonth + 1, 0, 23, 59, 59);

    const payments = await prisma.payment.findMany({
      where: {
        lease: { property: { userId: request.userId } },
        dueDate: { gte: monthStart, lte: monthEnd },
      },
      include: {
        lease: {
          include: {
            property: { select: { id: true, roomNumber: true, floor: true } },
            tenant: { select: { id: true, name: true } },
          },
        },
      },
      orderBy: { dueDate: 'asc' },
    });

    const totalExpected = payments.reduce((sum, p) => sum + p.amount, 0);
    const totalPaid = payments.filter(p => p.status === 'PAID').reduce((sum, p) => sum + p.amount, 0);
    const totalPending = payments.filter(p => p.status === 'PENDING').reduce((sum, p) => sum + p.amount, 0);
    const totalOverdue = payments.filter(p => p.status === 'OVERDUE').reduce((sum, p) => sum + p.amount, 0);

    return reply.send({
      month: `${targetYear}-${String(targetMonth + 1).padStart(2, '0')}`,
      summary: { totalExpected, totalPaid, totalPending, totalOverdue },
      payments,
    });
  });

  // Batch pay multiple months at once with optional discount
  fastify.post('/payments/batch-pay', async (request, reply) => {
    const parsed = batchPaySchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const { leaseId, months, discount, method, receipt } = parsed.data;

    const lease = await prisma.lease.findFirst({
      where: { id: leaseId, property: { userId: request.userId } },
      include: { property: true },
    });

    if (!lease) {
      return reply.status(404).send({ error: '找不到此租約' });
    }

    // Find existing PENDING/OVERDUE payments, ordered by dueDate
    const existingPayments = await prisma.payment.findMany({
      where: { leaseId, status: { in: ['PENDING', 'OVERDUE'] } },
      orderBy: { dueDate: 'asc' },
    });

    const paymentIds: string[] = [];
    const perMonthDiscount = Math.floor(discount / months);
    const firstMonthExtra = discount - perMonthDiscount * months;
    const now = new Date();

    // Use existing pending payments first, then create new ones for future months
    let used = 0;
    for (const p of existingPayments) {
      if (used >= months) break;
      paymentIds.push(p.id);
      used++;
    }

    // Create missing future payments if needed
    if (used < months) {
      // Find the latest payment dueDate to start from
      const allPayments = await prisma.payment.findMany({
        where: { leaseId },
        orderBy: { dueDate: 'desc' },
        take: 1,
      });

      let lastDue = allPayments.length > 0 ? new Date(allPayments[0].dueDate) : now;

      for (let i = used; i < months; i++) {
        lastDue = new Date(lastDue.getFullYear(), lastDue.getMonth() + 1, 1);
        const newPayment = await prisma.payment.create({
          data: {
            leaseId,
            amount: lease.monthlyRent,
            dueDate: lastDue,
            status: 'PENDING',
          },
        });
        paymentIds.push(newPayment.id);
      }
    }

    // Mark all as paid with distributed discount
    for (let i = 0; i < paymentIds.length; i++) {
      const d = i === 0 ? perMonthDiscount + firstMonthExtra : perMonthDiscount;
      await prisma.payment.update({
        where: { id: paymentIds[i] },
        data: {
          status: 'PAID',
          paidDate: now,
          method,
          receipt,
          discount: d,
        },
      });
    }

    return reply.send({
      paid: paymentIds.length,
      totalAmount: lease.monthlyRent * months,
      discount,
      finalAmount: lease.monthlyRent * months - discount,
    });
  });

  // Mark overdue payments (can be called periodically)
  fastify.post('/payments/mark-overdue', async (request, reply) => {
    const result = await prisma.payment.updateMany({
      where: {
        status: 'PENDING',
        dueDate: { lt: new Date() },
        lease: { property: { userId: request.userId } },
      },
      data: { status: 'OVERDUE' },
    });

    return reply.send({ updated: result.count });
  });
}
