const fs = require('fs');
const path = require('path');

const apiBase = process.env.API_BASE_URL || 'http://localhost:3001';
const supabaseUrl = process.env.SUPABASE_URL || '';
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || '';
const dist = path.join(__dirname, 'dist');

fs.mkdirSync(dist, { recursive: true });

const pages = ['index.html', 'request-logs.html'];

for (const page of pages) {
  const src = path.join(__dirname, page);
  if (!fs.existsSync(src)) continue;
  let html = fs.readFileSync(src, 'utf-8');
  html = html.replace("'API_PLACEHOLDER'", `'${apiBase}'`);
  html = html.replace("'SUPABASE_URL_PLACEHOLDER'", `'${supabaseUrl}'`);
  html = html.replace("'SUPABASE_ANON_KEY_PLACEHOLDER'", `'${supabaseAnonKey}'`);
  fs.writeFileSync(path.join(dist, page), html);
}

console.log(`Built ${pages.length} pages with API_BASE_URL=${apiBase}`);
