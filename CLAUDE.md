# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rental Suite Manager — a cross-platform suite management system (macOS, Windows, Web, Android, iOS) for landlords. Turborepo monorepo with a Fastify API backend, Flutter mobile app, and shared packages.

## Monorepo Structure

- `apps/api/` — Node.js + Fastify v5 backend (TypeScript, port 3001)
- `apps/mobile/` — Flutter cross-platform app (Dart, SDK ^3.11.1)
- `packages/db/` — Prisma v6 ORM client (PostgreSQL via Supabase)
- `packages/shared/` — Shared TypeScript types/interfaces
- `packages/design-tokens/` — Design system constants (colors, spacing, typography)

## Commands

### Root (Turborepo)
```bash
pnpm dev          # Run all apps in dev mode
pnpm build        # Build all packages and apps
pnpm lint         # Lint all packages
pnpm test         # Run all tests
pnpm db:generate  # Generate Prisma client
pnpm db:push      # Push schema to database
```

### API (`apps/api/`)
```bash
pnpm dev           # tsx watch src/index.ts
pnpm test          # vitest run
pnpm lint          # eslint src/
```

### Mobile (`apps/mobile/`)
```bash
flutter run                    # Run the app
flutter run -d macos           # Run on macOS
flutter test                   # Run tests
flutter analyze                # Static analysis
```

### Database (`packages/db/`)
```bash
pnpm db:generate    # prisma generate
pnpm db:push        # prisma db push
pnpm db:migrate     # prisma migrate dev
pnpm db:studio      # Open Prisma Studio GUI
```

## Architecture

### Authentication Flow
Supabase Auth (email/password) → JWT Bearer token → API validates via Supabase ES256 public key (`apps/api/src/plugins/auth.ts`) → Auto-creates user in Prisma DB on first API call.

### API Pattern
Routes in `apps/api/src/routes/` register as Fastify plugins. Request/response validation uses Zod schemas in `apps/api/src/schemas/`. All routes require auth (Bearer token). The auth plugin attaches `request.userId` after JWT verification.

### Mobile Pattern
Screens in `apps/mobile/lib/screens/`, services in `lib/services/`, models in `lib/models/`. `ApiService` injects Supabase session token into HTTP requests. Models use `fromJson` factory constructors.

### Database
Prisma schema at `packages/db/prisma/schema.prisma`. Key models: User, Property, Tenant, Lease, Payment, MeterReading, MaintenanceRequest. Property has status enum: VACANT, OCCUPIED, MAINTENANCE, ARCHIVED.

## API Endpoints

Base: `http://localhost:3001`
- `GET /health` — Health check (no auth)
- `POST/GET/PUT/DELETE /api/properties` — Property CRUD (auth required)
- `PATCH /api/properties/:id/archive` — Archive property
- GET supports query params: `status`, `floor`, `sort`, `order`, `page`, `limit`

## Environment

`.env` at repo root contains `DATABASE_URL`, `DIRECT_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`. The mobile app has Supabase credentials in `lib/main.dart`.

## Project Spec

Full specification with all stories and tasks is in `docs/PROJECT_SPEC.md`. Completed: S-01 (Infrastructure), S-02 (Auth), S-03 (Property CRUD). Next up: S-04 (Tenant Management).

## Design System

Primary color: #2563EB (blue-600). Design tokens in `packages/design-tokens/src/index.ts` define colors, spacing scale, typography, and border radii shared across platforms.
