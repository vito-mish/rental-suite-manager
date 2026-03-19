import Fastify from 'fastify';
import cors from '@fastify/cors';
import propertyRoutes from './routes/properties';
import tenantRoutes from './routes/tenants';
import leaseRoutes from './routes/leases';

const app = Fastify({ logger: true });

app.register(cors, { origin: true });

app.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

app.register(propertyRoutes, { prefix: '/api' });
app.register(tenantRoutes, { prefix: '/api' });
app.register(leaseRoutes, { prefix: '/api' });

const start = async () => {
  const port = Number(process.env.PORT) || 3001;
  await app.listen({ port, host: '0.0.0.0' });
  console.log(`API server running on http://localhost:${port}`);
};

start();
