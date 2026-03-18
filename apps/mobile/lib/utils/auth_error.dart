String localizeAuthError(String message) {
  switch (message) {
    case 'Invalid login credentials':
      return 'Email 或密碼錯誤，或信箱尚未驗證';
    case 'Email not confirmed':
      return '信箱尚未驗證，請先確認驗證信';
    case 'User already registered':
      return '此 Email 已註冊';
    case 'Signup requires a valid password':
      return '請輸入有效的密碼';
    case 'Password should be at least 6 characters':
      return '密碼至少需要 6 個字元';
    case 'For security purposes, you can only request this once every 60 seconds':
      return '請等待 60 秒後再試';
    case 'Email rate limit exceeded':
      return 'Email 發送次數已達上限，請稍後再試';
    default:
      if (message.contains('email')) {
        return 'Email 相關錯誤：$message';
      }
      return '發生錯誤：$message';
  }
}
