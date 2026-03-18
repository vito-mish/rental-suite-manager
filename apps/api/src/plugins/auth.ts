import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { importJWK, jwtVerify, JWK } from 'jose';
import { prisma } from '@rental-suite/db';

const SUPABASE_JWK: JWK = {
  x: "rKwrGdLf4328pZQsC7WGNWP_CiSFVpzzqsdSozdzJAQ",
  y: "1F7jtLfV-fdoiGZ5egkHAv_bYGkCH89bp0lOksDK1aE",
  alg: "ES256",
  crv: "P-256",
  ext: true,
  kid: "fc68c791-a0eb-4b29-995d-4e30b87fa1bc",
  kty: "EC",
  key_ops: ["verify"],
};

declare module 'fastify' {
  interface FastifyRequest {
    userId: string;
  }
}

let publicKey: Awaited<ReturnType<typeof importJWK>> | null = null;

async function getPublicKey() {
  if (!publicKey) {
    publicKey = await importJWK(SUPABASE_JWK, 'ES256');
  }
  return publicKey;
}

export async function authHook(request: FastifyRequest, reply: FastifyReply) {
  const authHeader = request.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return reply.status(401).send({ error: '未提供認證 Token' });
  }

  const token = authHeader.slice(7);
  try {
    const key = await getPublicKey();
    const { payload } = await jwtVerify(token, key);
    const userId = payload.sub;
    if (!userId) {
      return reply.status(401).send({ error: '無效的 Token' });
    }

    // Auto-create user on first API call
    await prisma.user.upsert({
      where: { id: userId },
      update: {},
      create: {
        id: userId,
        email: (payload.email as string) || '',
      },
    });

    request.userId = userId;
  } catch (err) {
    return reply.status(401).send({ error: '無效的 Token' });
  }
}

export default async function authPlugin(fastify: FastifyInstance) {
  fastify.decorateRequest('userId', '');
  fastify.addHook('onRequest', authHook);
}
