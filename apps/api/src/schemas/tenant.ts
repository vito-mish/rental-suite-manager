import { z } from 'zod';

export const createTenantSchema = z.object({
  name: z.string().min(1).max(100),
  phone: z.string().min(1).max(20),
  email: z.union([z.string().email(), z.literal('')]).optional(),
  idNumber: z.union([z.string().max(20), z.literal('')]).optional(),
  lineId: z.union([z.string().max(50), z.literal('')]).optional(),
  moveInDate: z.string().datetime().optional(),
  moveOutDate: z.string().datetime().optional(),
  emergencyContacts: z.array(z.object({
    name: z.string().min(1).max(100),
    phone: z.string().min(1).max(20),
    isCoResident: z.boolean().default(false),
  })).optional(),
});

export const updateTenantSchema = createTenantSchema.partial();

export const listTenantQuerySchema = z.object({
  search: z.string().optional(),
  sort: z.enum(['name', 'phone', 'createdAt', 'moveInDate']).optional().default('createdAt'),
  order: z.enum(['asc', 'desc']).optional().default('desc'),
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(20),
});

export type CreateTenantInput = z.infer<typeof createTenantSchema>;
export type UpdateTenantInput = z.infer<typeof updateTenantSchema>;
export type ListTenantQuery = z.infer<typeof listTenantQuerySchema>;
