# rental-suite-manager

> Manage smarter, rent easier.

跨平台套房管理系統，支援 macOS、Windows、Web、Android、iOS。

---

## 目錄

- [專案資訊](#專案資訊)
- [Sprint 規劃](#sprint-規劃)
- [S-01 專案基礎建設與跨平台架構](#s-01-專案基礎建設與跨平台架構)
- [S-02 房東帳號與身份驗證](#s-02-房東帳號與身份驗證)
- [S-03 房源管理套房-crud](#s-03-房源管理套房-crud)
- [S-04 租客管理](#s-04-租客管理)
- [S-05 租約合約管理](#s-05-租約合約管理)
- [S-06 租金收款與帳務管理](#s-06-租金收款與帳務管理)
- [S-07 水電錶抄表管理](#s-07-水電錶抄表管理)
- [S-08 維修報修管理](#s-08-維修報修管理)
- [S-09 儀表板與數據總覽](#s-09-儀表板與數據總覽)
- [S-10 通知與推播系統](#s-10-通知與推播系統)
- [S-11 租客繳費查詢網頁](#s-11-租客繳費查詢網頁)
- [S-12 API Request Log 查詢系統](#s-12-api-request-log-查詢系統)
- [S-13 macOS App 打包與發佈](#s-13-macos-app-打包與發佈)

---

## Sprint 規劃

| Sprint | 主題 | 狀態 | 詳細文件 |
|--------|------|------|----------|
| Sprint 1 | 基礎建設與認證系統 | ✅ 已完成 | [SPRINT_1_DONE.md](SPRINT_1_DONE.md) |
| Sprint 2 | 房源、租客、租約、收租核心 | ✅ 已完成 | [SPRINT_2_DONE.md](SPRINT_2_DONE.md) |
| Sprint 3 | 核心業務流程完善（合約、帳務、匯入） | 🔄 進行中 | [SPRINT_3.md](SPRINT_3.md) |
| Sprint 4 | 營運管理（抄表、報修、儀表板） | 待開始 | [SPRINT_4.md](SPRINT_4.md) |
| Sprint 5 | 多平台擴展與通知系統 | 待開始 | [SPRINT_5.md](SPRINT_5.md) |

---

## 專案資訊

| 項目 | 內容 |
|------|------|
| Repo | `rental-suite-manager` |
| 副標題 | Manage smarter, rent easier. |
| 支援平台 | macOS、Windows、Web、Android、iOS |
| Stories | 13 |
| Tasks | 71 |

---

## S-01 專案基礎建設與跨平台架構

**目標**：建立整個專案的技術底座，確保各平台可以共用程式碼並獨立部署。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-01 | 建立 Monorepo 結構（Turborepo），規劃 `apps/` 與 `packages/` 目錄 | infra | ✅ Done |
| T-02a | 設定 Flutter 跨平台框架，驗證 macOS 建置與執行 | FE | ✅ Done |
| T-02b | 驗證 Windows 建置與執行 | FE | Sprint 5 |
| T-02c | 驗證 Android 建置與執行 | FE | Sprint 5 |
| T-02d | 驗證 iOS 建置與執行 | FE | Sprint 5 |
| T-03 | 建立 Web 前端專案（純 HTML + Tailwind CSS），租客查詢頁面 | FE | ✅ Done |
| T-04 | 設定後端 API 服務（Node.js + Fastify），定義 REST 規範 | BE | ✅ Done |
| T-05 | 建立 CI/CD Pipeline（GitHub Actions），自動化各平台建置與測試 | infra | Sprint 5 |
| T-06 | 設定共用設計 Token（Design System），統一色彩、字體、間距規範 | design | ✅ Done |

---

## S-02 房東帳號與身份驗證

**目標**：提供安全的帳號系統，支援多種登入方式與多裝置同步。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-07 | 實作 Email / 密碼註冊與登入流程（Supabase Auth） | BE | ✅ Done |
| T-08 | 整合 Google / Apple SSO 第三方登入 | BE | Sprint 5 |
| T-09 | JWT Access Token + Refresh Token 管理機制（Supabase 自動處理） | BE | ✅ Done |
| T-10 | 設計登入、忘記密碼、重設密碼畫面（macOS 驗證通過） | FE | ✅ Done |
| T-11 | 多裝置同步登入狀態管理與登出處理（Supabase session） | FE | ✅ Done |

---

## S-03 房源管理（套房 CRUD）

**目標**：讓房東可以完整管理名下所有套房，包含資訊、照片與平面圖。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-12 | 設計房源資料模型（樓層、房號、坪數、設施、狀態） | BE | ✅ Done |
| T-13 | 實作房源新增、編輯、刪除 API | BE | ✅ Done |
| T-14 | 房源列表頁面，支援篩選（狀態）與排序 | FE | ✅ Done |
| T-15 | 房源詳細資訊頁面，顯示出租狀態與目前租客資訊 | FE | ✅ Done |
| T-17 | 建立樓層平面圖視覺化介面：以 2D 色塊呈現各樓層房間配置，顏色對應房源狀態（綠=空房、藍=出租中、橘=維修中），點擊色塊可跳轉至該房源詳情頁，支援樓層切換 | FE | ✅ Done |
| T-18 | 批次匯入房源（CSV / Excel 格式支援） | BE | Sprint 3 |

---

## S-04 租客管理

**目標**：管理所有租客資料，記錄入退房歷史與相關文件。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-19 | 設計租客資料模型（姓名、身份證、聯絡方式、入住日期） | BE | ✅ Done |
| T-20 | 租客新增、編輯、刪除與搜尋 API | BE | ✅ Done |
| T-21 | 租客列表與詳細資料頁面 | FE | ✅ Done |
| T-22 | 租客入住、退房流程操作介面 | FE | ✅ Done |
| T-23 | 上傳租客身份證件與合約文件（PDF 支援） | BE | ✅ Done |
| T-24 | 租客歷史紀錄查詢（曾住哪間房、租期） | FE | ✅ Done |

---

## S-05 租約合約管理

**目標**：數位化租約流程，支援模板、版本管理與到期提醒。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-25 | 建立租約資料模型（租期、租金、押金、特殊條款） | BE | ✅ Done |
| T-26 | 合約新增與版本管理 API | BE | ✅ Done |
| T-27 | 合約模板系統，支援自訂欄位並自動填入租客／房源資料 | FE | Sprint 3 |
| T-28 | 合約到期提醒機制（在到期前 N 天自動推播 / Email） | BE | Sprint 3 |
| T-29 | 合約 PDF 匯出與列印功能 | FE | Sprint 3 |

---

## S-06 租金收款與帳務管理

**目標**：自動化租金追蹤，提供清楚的帳務報表與逾期通知。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-30 | 建立帳務資料模型（應收租金、繳費紀錄、逾期狀態） | BE | ✅ Done |
| T-31 | 每月自動產生應收帳款單 | BE | ✅ Done |
| T-32 | 手動標記繳費（現金 / 轉帳）並上傳收款憑證 | FE | ✅ Done |
| T-33 | 逾期未繳提醒通知（推播 + Email + SMS） | BE | Sprint 3 |
| T-34 | 月收入報表頁面（各房間收款狀況、總收入統計） | FE | ✅ Done |
| T-35 | 帳務匯出（Excel / CSV）功能 | FE | ✅ Done |
| T-36 | 水電費用分攤計算（公用電費按人頭或用量分攤） | BE | Sprint 3 |

---

## S-07 水電錶抄表管理

**目標**：數位化每月抄表流程，自動計算用量與應收費用。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-37 | 建立水錶 / 電錶抄表紀錄資料模型 | BE | Sprint 4 |
| T-38 | 抄表輸入介面，支援手動輸入與相機掃描（OCR） | FE | Sprint 4 |
| T-39 | 自動計算用量差值與應收金額 | BE | Sprint 4 |
| T-40 | 抄表歷史紀錄與用量趨勢圖表 | FE | Sprint 4 |
| T-41 | 每月抄表提醒推播通知 | BE | Sprint 4 |

---

## S-08 維修報修管理

**目標**：集中管理房屋維修需求，追蹤進度與費用。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-42 | 建立報修單資料模型（類別、描述、狀態、優先度） | BE | Sprint 4 |
| T-43 | 房東端報修單列表管理頁面（待處理 / 處理中 / 完成） | FE | Sprint 4 |
| T-44 | 維修費用紀錄與廠商資訊管理 | BE | Sprint 4 |
| T-45 | 報修照片上傳（前後對比） | FE | Sprint 4 |
| T-46 | 維修狀態更新推播通知（通知租客） | BE | Sprint 4 |

---

## S-09 儀表板與數據總覽

**目標**：提供房東一眼掌握整體出租狀況與財務健康度。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-47 | 首頁儀表板：出租率、本月收入、逾期帳款、待處理報修 | FE | Sprint 4 |
| T-48 | 收入趨勢折線圖（月度 / 年度） | FE | Sprint 4 |
| T-49 | 房間狀態色塊圖（空房 / 出租中 / 維修中） | FE | Sprint 4 |
| T-50 | Dashboard 資料 API 端點（聚合查詢，效能優化） | BE | Sprint 4 |

---

## S-10 通知與推播系統

**目標**：確保重要事件即時送達，支援所有平台的通知管道。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-51 | 整合 FCM（Firebase Cloud Messaging）支援 Android / iOS 推播 | BE | Sprint 5 |
| T-52 | macOS / Windows 桌面原生通知整合 | FE | Sprint 5 |
| T-53 | Email 通知整合（Resend / SendGrid） | BE | Sprint 5 |
| T-54 | 通知偏好設定頁面（各類通知開關） | FE | Sprint 5 |

---

## S-11 租客繳費查詢網頁

**目標**：提供租客自助查詢管道，透過網頁輸入姓名與電話即可查看合約與繳費紀錄。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-57 | 新增公開查詢 API（姓名+電話查詢合約與繳費紀錄），含 rate limit 與 CORS | BE | ✅ Done |
| T-58 | 建立租客查詢靜態網頁（`apps/web/`），純 HTML + Tailwind CSS，響應式 | FE | ✅ Done |
| T-59 | API 部署至 Render 免費方案 | infra | ✅ Done |
| T-60 | Web 部署至 Vercel 免費方案 | infra | ✅ Done |

---

## S-12 API Request Log 查詢系統

**目標**：記錄所有 API 請求並提供網頁查詢介面，方便監控系統運行狀態與除錯。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-61 | 建立 RequestLog 資料模型（method、url、statusCode、responseTime、ip、userAgent、userId） | BE | ✅ Done |
| T-62 | 實作 Fastify onResponse hook 自動記錄所有 request 至資料庫 | BE | ✅ Done |
| T-63 | 實作 GET /api/request-logs 查詢端點，支援 method / url / statusCode / 日期範圍 / 排除 URL / 分頁篩選（需認證） | BE | ✅ Done |
| T-64 | 建立 Request Logs 查詢網頁（`apps/web/request-logs.html`），支援 GitHub OAuth 登入與手動 Token 登入 | FE | ✅ Done |
| T-65 | 改造 keep-alive 改打 /health endpoint，使心跳紀錄也納入 request log，網頁提供隱藏 /health 選項 | BE | ✅ Done |

---

## S-13 macOS App 打包與發佈

**目標**：將 Flutter macOS app 打包為可分發的正式版本，包含簽名、圖示與安裝檔。

| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-66 | 設定 App Icon（1024x1024 icon set），替換 Flutter 預設圖示 | design | ✅ Done |
| T-67 | 設定 Bundle ID、App 名稱、版本號（CFBundleIdentifier、CFBundleShortVersionString） | infra | ✅ Done |
| T-68 | 設定 macOS entitlements（網路存取、檔案存取等沙盒權限） | infra | ✅ Done |
| T-69 | `flutter build macos --release` 產出正式 .app bundle，驗證功能正常 | FE | ✅ Done |
| T-70 | Apple Developer 簽名與公證（codesign + notarytool），確保 Gatekeeper 放行 | infra | 待取得 Apple Developer 帳號 |
| T-71 | 打包為 .dmg 安裝檔（create-dmg），含背景圖與 Applications 捷徑 | infra | ✅ Done |

---

*共 13 Stories、71 Tasks*