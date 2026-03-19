# Sprint 1 — 基礎建設與認證系統

> 狀態：✅ 已完成

## 範圍

### S-01 專案基礎建設與跨平台架構
| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-01 | 建立 Monorepo 結構（Turborepo），規劃 apps/ 與 packages/ 目錄 | infra | ✅ Done |
| T-02a | 設定 Flutter 跨平台框架，驗證 macOS 建置與執行 | FE | ✅ Done |
| T-04 | 設定後端 API 服務（Node.js + Fastify），定義 REST 規範 | BE | ✅ Done |
| T-06 | 設定共用設計 Token（Design System），統一色彩、字體、間距規範 | design | ✅ Done |

### S-02 房東帳號與身份驗證
| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-07 | 實作 Email / 密碼註冊與登入流程（Supabase Auth） | BE | ✅ Done |
| T-09 | JWT Access Token + Refresh Token 管理機制 | BE | ✅ Done |
| T-10 | 設計登入、忘記密碼、重設密碼畫面 | FE | ✅ Done |
| T-11 | 多裝置同步登入狀態管理與登出處理 | FE | ✅ Done |

## 交付成果
- Turborepo monorepo 架構就位（apps/api、apps/mobile、packages/db、packages/shared、packages/design-tokens）
- Fastify v5 API server 運行於 port 3001
- Flutter macOS app 可建置執行
- Supabase Auth 整合完成（註冊、登入、忘記密碼、JWT 驗證）
- Design tokens 統一色彩、字體、間距規範
