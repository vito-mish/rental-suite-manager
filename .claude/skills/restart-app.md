---
name: restart-app
description: Kill existing Flutter/SuiteHub processes and restart the app on macOS
user_invocable: true
---

# Restart App

Restart the Flutter macOS app. Always kill existing processes first to avoid duplicate instances.

## Steps

1. Kill any running Flutter and SuiteHub processes:
   ```bash
   pkill -f "flutter run" 2>/dev/null; pkill -f "SuiteHub" 2>/dev/null
   ```
2. Wait 2 seconds for cleanup.
3. Launch the app in background:
   ```bash
   cd apps/mobile && flutter run -d macos
   ```
4. Report status to the user.
