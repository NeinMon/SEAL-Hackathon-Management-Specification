import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/l10n_service.dart';

class FriendlyErrorMapper {
  const FriendlyErrorMapper._();

  static bool looksLikeNetworkError(Object exception) {
    final text = exception.toString().toLowerCase();
    return exception is TimeoutException ||
        text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection') ||
        text.contains('timed out') ||
        text.contains('failed host lookup');
  }

  static String message(Object exception) {
    final l10n = L10nService.strings;
    if (exception is AuthException) {
      final text = exception.message.toLowerCase();
      if (text.contains('invalid login credentials') ||
          text.contains('invalid_credentials')) {
        return l10n.errorInvalidCredentials;
      }
      if (text.contains('email not confirmed')) {
        return l10n.errorEmailNotConfirmed;
      }
      if (text.contains('otp') ||
          text.contains('verification token') ||
          text.contains('signup token')) {
        return l10n.errorInvalidOtp;
      }
      if (!_isTechnicalError(exception.message)) {
        return exception.message;
      }
      return l10n.unknownError;
    }
    if (exception is TimeoutException) {
      return l10n.errorConnectionTimeout;
    }
    if (exception is PostgrestException) {
      final text = exception.message.toLowerCase();
      if (exception.code == '42501' || text.contains('row-level security')) {
        return l10n.errorRlsPermissionDenied;
      }
      if (exception.code == '23505') {
        if (text.contains('team_invitations')) {
          return l10n.invitationAlreadyPending;
        }
        return l10n.errorDuplicateRecord;
      }
      if (exception.code == '23514') {
        return l10n.errorCheckConstraint;
      }
      if (text.contains('already on a team for this event')) {
        return l10n.alreadyOnEventTeamError;
      }
      return l10n.unknownError;
    }
    if (exception.toString().contains('PostgrestException')) {
      return l10n.unknownError;
    }
    if (looksLikeNetworkError(exception)) {
      return l10n.networkOfflineMessage;
    }
    return l10n.unknownError;
  }

  static bool _isTechnicalError(String message) {
    final text = message.toLowerCase();
    return text.contains('postgrest') ||
        text.contains('supabase') ||
        text.contains('stack') ||
        text.contains('sql') ||
        text.contains('database') ||
        text.contains('rls') ||
        text.contains('row-level security') ||
        text.contains('jwt') ||
        text.contains('socketexception') ||
        text.contains('stateerror');
  }
}
