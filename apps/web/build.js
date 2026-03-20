const fs = require('fs');
const path = require('path');

const apiBase = process.env.API_BASE_URL || 'http://localhost:3001';
const src = path.join(__dirname, 'index.html');
const dist = path.join(__dirname, 'dist');

fs.mkdirSync(dist, { recursive: true });

let html = fs.readFileSync(src, 'utf-8');
html = html.replace("'API_PLACEHOLDER'", `'${apiBase}'`);

fs.writeFileSync(path.join(dist, 'index.html'), html);
console.log(`Built with API_BASE_URL=${apiBase}`);
