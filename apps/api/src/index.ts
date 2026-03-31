import Fastify from 'fastify';
import cors from '@fastify/cors';
import rateLimit from '@fastify/rate-limit';
import propertyRoutes from './routes/properties';
import tenantRoutes from './routes/tenants';
import leaseRoutes from './routes/leases';
import paymentRoutes from './routes/payments';
import publicRoutes from './routes/public';
import requestLogRoutes from './routes/request-logs';
import { registerKeepAlive } from './plugins/keep-alive';
import { registerRequestLogger } from './plugins/request-logger';

const app = Fastify({ logger: true });

app.register(cors, { origin: true });
app.register(rateLimit, {
  global: false, // only apply to routes that opt in
});

app.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

app.register(propertyRoutes, { prefix: '/api' });
app.register(tenantRoutes, { prefix: '/api' });
app.register(leaseRoutes, { prefix: '/api' });
app.register(paymentRoutes, { prefix: '/api' });
app.register(publicRoutes, { prefix: '/api/public' });
app.register(requestLogRoutes, { prefix: '/api' });
registerKeepAlive(app);
registerRequestLogger(app);

const start = async () => {
  const port = Number(process.env.PORT) || 3001;
  await app.listen({ port, host: '0.0.0.0' });
  console.log(`API server running on http://localhost:${port}`);
};

start();
