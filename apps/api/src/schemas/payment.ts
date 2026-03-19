import { z } from 'zod';

const PaymentStatus = z.enum(['PENDING', 'PAID', 'OVERDUE']);
const PaymentMethod = z.enum(['CASH', 'TRANSFER']);

export const markPaidSchema = z.object({
  method: PaymentMethod,
  receipt: z.string().optional(),
});

export const listPaymentQuerySchema = z.object({
  leaseId: z.string().optional(),
  status: PaymentStatus.optional(),
  search: z.string().optional(),
  month: z.string().optional(), // YYYY-MM format
  sort: z.enum(['dueDate', 'amount', 'createdAt']).optional().default('dueDate'),
  order: z.enum(['asc', 'desc']).optional().default('desc'),
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(20),
});

export type MarkPaidInput = z.infer<typeof markPaidSchema>;
export type ListPaymentQuery = z.infer<typeof listPaymentQuerySchema>;
