---
name: view-request-logs
description: Start the API server and open the request logs web page
user_invocable: true
---

# View Request Logs

啟動 API 並開啟 Request Logs 查詢頁面（含 GitHub OAuth 登入）。

## Steps

1. Kill any existing API dev processes and web server:
   ```bash
   pkill -f "tsx watch" 2>/dev/null; pkill -f "pnpm dev" 2>/dev/null; pkill -f "python3 -m http.server 3002" 2>/dev/null
   ```
2. Wait 2 seconds for cleanup.
3. Start the API dev server in background:
   ```bash
   cd /Users/dwavemac/Desktop/self-repo/rental-suite-manager && pnpm dev
   ```
4. Start a local web server for the request-logs page (needed for OAuth redirect):
   ```bash
   cd /Users/dwavemac/Desktop/self-repo/rental-suite-manager/apps/web && python3 -m http.server 3002
   ```
5. Wait 3 seconds for servers to be ready.
6. Open the request logs page in the browser:
   ```bash
   open http://localhost:3002/request-logs.html
   ```
7. Tell the user the page is open, they can click "使用 GitHub 登入" to authenticate.
