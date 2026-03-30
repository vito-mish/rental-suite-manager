import { FastifyInstance } from 'fastify';
import { prisma } from '@rental-suite/db';

const INTERVAL_MS = 5 * 60 * 1000; // 每 5 分鐘
const FAILURE_THRESHOLD = 3;
const NOTIFY_EMAIL = process.env.NOTIFY_EMAIL || 'mishmshigh@gmail.com';
const RESEND_API_KEY = process.env.RESEND_API_KEY || '';
const SMTP_FROM = process.env.SMTP_FROM || 'Rental Suite <onboarding@resend.dev>';

let consecutiveFailures = 0;
let notified = false;
let timer: ReturnType<typeof setInterval>;

function ts() {
  return new Date().toISOString();
}

async function pingDb(): Promise<boolean> {
  try {
    await prisma.$queryRaw`SELECT 1`;
    return true;
  } catch (err) {
    console.error(`[keep-alive] DB ping failed:`, (err as Error).message);
    return false;
  }
}

async function sendAlert(subject: string, body: string) {
  if (!RESEND_API_KEY) {
    console.warn(`[keep-alive] No RESEND_API_KEY, skipping email: ${subject}`);
    return;
  }

  try {
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: SMTP_FROM,
        to: [NOTIFY_EMAIL],
        subject,
        text: body,
      }),
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`Resend API ${res.status}: ${text}`);
    }

    console.log(`[keep-alive] Alert sent to ${NOTIFY_EMAIL}`);
  } catch (err) {
    console.error(`[keep-alive] Email failed:`, (err as Error).message);
  }
}

async function tick() {
  const healthy = await pingDb();

  if (healthy) {
    if (notified) {
      await sendAlert(
        '✅ Rental Suite DB 已恢復',
        `DB 連線已恢復正常。\n時間: ${ts()}`
      );
      notified = false;
    }
    if (consecutiveFailures > 0) {
      console.log(`[keep-alive] Recovered after ${consecutiveFailures} failure(s)`);
    }
    consecutiveFailures = 0;
  } else {
    consecutiveFailures++;
    console.log(`[keep-alive] FAIL (${consecutiveFailures}/${FAILURE_THRESHOLD})`);

    if (consecutiveFailures >= FAILURE_THRESHOLD && !notified) {
      await sendAlert(
        '🚨 Rental Suite DB 連線異常',
        [
          `DB 連續 ${consecutiveFailures} 次 ping 失敗。`,
          `時間: ${ts()}`,
          '',
          '請檢查：',
          '1. Supabase 服務狀態',
          '2. DATABASE_URL 連線設定',
          '3. 網路連線',
        ].join('\n')
      );
      notified = true;
    }
  }
}

export async function registerKeepAlive(app: FastifyInstance) {
  app.addHook('onReady', () => {
    console.log(`[keep-alive] Started (interval: ${INTERVAL_MS / 1000}s, notify: ${NOTIFY_EMAIL})`);
    timer = setInterval(tick, INTERVAL_MS);
    // 啟動後立即 ping 一次
    tick();
  });

  app.addHook('onClose', () => {
    clearInterval(timer);
    console.log('[keep-alive] Stopped');
  });
}
