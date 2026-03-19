# Sprint 5 — 多平台擴展與通知系統

> 優先度：低
> 目標：擴展至所有目標平台，建立完整通知管道。

## 範圍

### S-01 跨平台架構（剩餘）
| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-02b | 驗證 Windows 建置與執行 | FE | |
| T-02c | 驗證 Android 建置與執行 | FE | |
| T-02d | 驗證 iOS 建置與執行 | FE | |
| T-03 | 建立 Web 前端專案（Next.js） | FE | |
| T-05 | CI/CD Pipeline（GitHub Actions） | infra | |

### S-02 身份驗證（剩餘）
| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-08 | Google / Apple SSO 第三方登入 | BE | |

### S-10 通知與推播系統
| Task | 說明 | 類型 | 狀態 |
|------|------|------|------|
| T-51 | 整合 FCM 推播（Android / iOS） | BE | |
| T-52 | macOS / Windows 桌面原生通知 | FE | |
| T-53 | Email 通知整合（Resend / SendGrid） | BE | |
| T-54 | 通知偏好設定頁面 | FE | |

## 交付標準
- 所有目標平台皆可建置執行
- SSO 登入可用
- 推播、Email、桌面通知管道皆運作
- CI/CD 自動化建置與測試
