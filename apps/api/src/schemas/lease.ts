import { z } from 'zod';

const LeaseStatus = z.enum(['ACTIVE', 'EXPIRED', 'TERMINATED']);

export const moveInSchema = z.object({
  tenantId: z.string().min(1),
  propertyId: z.string().min(1),
  startDate: z.string().datetime(),
  endDate: z.string().datetime(),
  monthlyRent: z.number().int().positive(),
  deposit: z.number().int().min(0),
  terms: z.string().optional(),
});

export const updateLeaseSchema = z.object({
  endDate: z.string().datetime().optional(),
  monthlyRent: z.number().int().positive().optional(),
  deposit: z.number().int().min(0).optional(),
  terms: z.string().optional(),
});

export const listLeaseQuerySchema = z.object({
  status: LeaseStatus.optional(),
  search: z.string().optional(),
  propertyId: z.string().optional(),
  tenantId: z.string().optional(),
  sort: z.enum(['startDate', 'endDate', 'createdAt', 'monthlyRent']).optional().default('createdAt'),
  order: z.enum(['asc', 'desc']).optional().default('desc'),
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(20),
});

export type MoveInInput = z.infer<typeof moveInSchema>;
export type UpdateLeaseInput = z.infer<typeof updateLeaseSchema>;
export type ListLeaseQuery = z.infer<typeof listLeaseQuerySchema>;
