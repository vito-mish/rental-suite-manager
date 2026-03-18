// Design tokens for rental-suite-manager
// Shared across Web (Tailwind) and Flutter

export const colors = {
  primary: '#2563EB',       // blue-600
  primaryLight: '#3B82F6',  // blue-500
  primaryDark: '#1D4ED8',   // blue-700
  secondary: '#64748B',     // slate-500
  success: '#16A34A',       // green-600
  warning: '#D97706',       // amber-600
  error: '#DC2626',         // red-600
  background: '#F8FAFC',    // slate-50
  surface: '#FFFFFF',
  textPrimary: '#0F172A',   // slate-900
  textSecondary: '#475569', // slate-600
  border: '#E2E8F0',        // slate-200
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
} as const;

export const fontSize = {
  xs: 12,
  sm: 14,
  base: 16,
  lg: 18,
  xl: 20,
  '2xl': 24,
  '3xl': 30,
} as const;

export const borderRadius = {
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  full: 9999,
} as const;
