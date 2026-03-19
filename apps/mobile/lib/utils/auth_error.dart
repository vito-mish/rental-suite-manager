import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

String localizeAuthError(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;
  switch (message) {
    case 'Invalid login credentials':
      return l10n.authInvalidCredentials;
    case 'Email not confirmed':
      return l10n.authEmailNotConfirmed;
    case 'User already registered':
      return l10n.authEmailRegistered;
    case 'Signup requires a valid password':
      return l10n.authInvalidPassword;
    case 'Password should be at least 6 characters':
      return l10n.authPasswordMinLength;
    case 'For security purposes, you can only request this once every 60 seconds':
      return l10n.authRateLimit;
    case 'Email rate limit exceeded':
      return l10n.authEmailRateLimit;
    default:
      if (message.contains('email')) {
        return l10n.authEmailError(message);
      }
      return l10n.authGenericError(message);
  }
}
