import Fastify from 'fastify';
import cors from '@fastify/cors';

const app = Fastify({ logger: true });

app.register(cors, { origin: true });

app.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

const start = async () => {
  const port = Number(process.env.PORT) || 3001;
  await app.listen({ port, host: '0.0.0.0' });
  console.log(`API server running on http://localhost:${port}`);
};

start();
