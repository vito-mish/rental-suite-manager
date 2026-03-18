// Property (房源)
export interface Property {
  id: string;
  name: string;
  floor: number;
  roomNumber: string;
  area: number; // 坪數
  status: PropertyStatus;
  facilities: string[];
  createdAt: Date;
  updatedAt: Date;
}

export enum PropertyStatus {
  VACANT = 'VACANT',         // 空房
  OCCUPIED = 'OCCUPIED',     // 出租中
  MAINTENANCE = 'MAINTENANCE', // 維修中
  ARCHIVED = 'ARCHIVED',     // 已封存
}

// Tenant (租客)
export interface Tenant {
  id: string;
  name: string;
  phone: string;
  email?: string;
  idNumber?: string;
  moveInDate?: Date;
  moveOutDate?: Date;
  createdAt: Date;
  updatedAt: Date;
}

// Lease (租約)
export interface Lease {
  id: string;
  propertyId: string;
  tenantId: string;
  startDate: Date;
  endDate: Date;
  monthlyRent: number;
  deposit: number;
  terms?: string;
  status: LeaseStatus;
  createdAt: Date;
  updatedAt: Date;
}

export enum LeaseStatus {
  ACTIVE = 'ACTIVE',
  EXPIRED = 'EXPIRED',
  TERMINATED = 'TERMINATED',
}

// Payment (繳費紀錄)
export interface Payment {
  id: string;
  leaseId: string;
  amount: number;
  dueDate: Date;
  paidDate?: Date;
  status: PaymentStatus;
  method?: PaymentMethod;
  createdAt: Date;
}

export enum PaymentStatus {
  PENDING = 'PENDING',
  PAID = 'PAID',
  OVERDUE = 'OVERDUE',
}

export enum PaymentMethod {
  CASH = 'CASH',
  TRANSFER = 'TRANSFER',
}

// Meter Reading (抄表)
export interface MeterReading {
  id: string;
  propertyId: string;
  type: MeterType;
  reading: number;
  readingDate: Date;
  createdAt: Date;
}

export enum MeterType {
  WATER = 'WATER',
  ELECTRICITY = 'ELECTRICITY',
}

// Maintenance Request (報修)
export interface MaintenanceRequest {
  id: string;
  propertyId: string;
  tenantId?: string;
  category: string;
  description: string;
  priority: MaintenancePriority;
  status: MaintenanceStatus;
  cost?: number;
  createdAt: Date;
  updatedAt: Date;
}

export enum MaintenancePriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  URGENT = 'URGENT',
}

export enum MaintenanceStatus {
  PENDING = 'PENDING',
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
}
