import { describe, it, expect, afterAll } from 'vitest';
import Fastify from 'fastify';

function buildApp() {
  const app = Fastify();
  app.get('/health', async () => {
    return { status: 'ok', timestamp: new Date().toISOString() };
  });
  return app;
}

describe('GET /health', () => {
  const app = buildApp();

  afterAll(() => app.close());

  it('returns status ok', async () => {
    const res = await app.inject({ method: 'GET', url: '/health' });
    expect(res.statusCode).toBe(200);
    const body = JSON.parse(res.body);
    expect(body.status).toBe('ok');
    expect(body.timestamp).toBeDefined();
  });
});
