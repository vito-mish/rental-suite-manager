import { z } from 'zod';

const PropertyStatus = z.enum(['VACANT', 'OCCUPIED', 'MAINTENANCE', 'ARCHIVED']);

export const createPropertySchema = z.object({
  name: z.string().min(1).max(100),
  floor: z.number().int(),
  roomNumber: z.string().min(1).max(20),
  area: z.number().positive(),
  monthlyRent: z.number().int().positive(),
  status: PropertyStatus.optional().default('VACANT'),
  facilities: z.array(z.string()).optional().default([]),
});

export const updatePropertySchema = createPropertySchema.partial();

export const listPropertyQuerySchema = z.object({
  status: PropertyStatus.optional(),
  floor: z.coerce.number().int().optional(),
  sort: z.enum(['name', 'floor', 'roomNumber', 'area', 'createdAt']).optional().default('createdAt'),
  order: z.enum(['asc', 'desc']).optional().default('desc'),
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(20),
});

export type CreatePropertyInput = z.infer<typeof createPropertySchema>;
export type UpdatePropertyInput = z.infer<typeof updatePropertySchema>;
export type ListPropertyQuery = z.infer<typeof listPropertyQuerySchema>;
