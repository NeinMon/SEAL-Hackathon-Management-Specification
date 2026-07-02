import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'supabase_config.dart';

export 'constants/constants.dart';

class AppRoles {
  const AppRoles._();

  static const participant = 'participant';
  static const judge = 'judge';
  static const mentor = 'mentor';
  static const organizer = 'organizer';

  static const participantCreators = {participant, organizer};
  static const scorers = {judge};

  static String label(String role) {
    return switch (role) {
      participant => AppStrings.roleParticipant,
      judge => AppStrings.roleJudge,
      mentor => AppStrings.roleMentor,
      organizer => AppStrings.roleOrganizer,
      _ => role,
    };
  }
}

class EventCatalog {
  const EventCatalog._();

  static const sortStartAsc = 'start_asc';
  static const sortStartDesc = 'start_desc';
  static const sortTitleAsc = 'title_asc';
  static const sortTitleDesc = 'title_desc';
  static const sortDeadlineAsc = 'deadline_asc';
  static const sortDeadlineDesc = 'deadline_desc';

  static const filterAll = 'all';
  static const filterUpcoming = 'upcoming';
  static const filterActive = 'active';
  static const filterClosed = 'closed';
  static const filterRegistrationOpen = 'registration_open';

  static const sortLabels = <String, String>{
    sortStartAsc: AppStrings.sortStartAsc,
    sortStartDesc: AppStrings.sortStartDesc,
    sortTitleAsc: AppStrings.sortTitleAsc,
    sortTitleDesc: AppStrings.sortTitleDesc,
    sortDeadlineAsc: AppStrings.sortDeadlineAsc,
    sortDeadlineDesc: AppStrings.sortDeadlineDesc,
  };

  static const filterLabels = <String, String>{
    filterAll: AppStrings.allFilter,
    filterUpcoming: AppStrings.statusUpcoming,
    filterActive: AppStrings.statusActive,
    filterClosed: AppStrings.statusClosed,
    filterRegistrationOpen: AppStrings.filterRegistrationOpen,
  };
}

// AppRoutes lives in core/constants/app_routes.dart

class AppValidators {
  const AppValidators._();

  static const maxEventSearchLength = 80;
  static const maxTeamNameLength = 60;
  static const maxProjectNameLength = 80;
  static const maxDescriptionLength = 2000;
  static const maxChatMessageLength = 1000;
  static const maxNotificationTitleLength = 120;
  static const maxNotificationContentLength = 500;
  static const minTeamSize = 1;
  static const maxTeamSize = 20;

  static const notificationTypes = {
    'invitation',
    'score',
    'reminder',
    'system',
    'announcement',
  };

  static bool isValidEmail(String value) {
    final clean = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(clean);
  }

  static String? loginEmail(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationEmailRequired;
    if (!isValidEmail(clean)) return AppStrings.validationEmailInvalid;
    return null;
  }

  static String? loginPassword(String? value) {
    final raw = value ?? '';
    if (raw.isEmpty) return AppStrings.validationPasswordRequired;
    if (raw.length < 6) return AppStrings.validationPasswordMinLength;
    return null;
  }

  static String? confirmPassword(String? password, String? confirm) {
    if ((confirm ?? '').isEmpty) {
      return AppStrings.validationConfirmPasswordRequired;
    }
    final passwordError = loginPassword(password);
    if (passwordError != null) return passwordError;
    if (password != confirm) return AppStrings.validationPasswordMismatch;
    return null;
  }

  static String? signupOtp(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationOtpRequired;
    if (!RegExp(r'^\d{6}$').hasMatch(clean)) {
      return AppStrings.validationOtpInvalid;
    }
    return null;
  }

  static String? registerName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationFullNameRequired;
    if (clean.length < 2) return AppStrings.validationFullNameMinLength;
    return null;
  }

  static String? registerUniversity(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationUniversityRequired;
    if (clean.length < 2) return AppStrings.validationUniversityMinLength;
    return null;
  }

  static String? eventSearchQuery(String value) {
    if (value.trim().length > maxEventSearchLength) {
      return AppStrings.validationSearchMaxLength(maxEventSearchLength);
    }
    return null;
  }

  static String? requireSupabaseReady() {
    if (!SupabaseGateway.isReady) {
      return AppStrings.validationSupabaseNotReady;
    }
    return null;
  }

  static String? requireUserId(String? userId, {String? label}) {
    final resolvedLabel = label ?? AppStrings.validationUserLabel;
    if (userId == null || userId.trim().isEmpty) {
      return AppStrings.validationInvalidUser(resolvedLabel);
    }
    return null;
  }

  static bool isValidWebUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.');
  }

  static String? webUrl(String? value, {required String label}) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationFieldRequired(label);
    if (!isValidWebUrl(clean)) return AppStrings.validationInvalidUrl(label);
    return null;
  }

  static String? optionalWebUrl(String? value, {required String label}) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return null;
    if (!isValidWebUrl(clean)) return AppStrings.validationInvalidUrl(label);
    return null;
  }

  static String? teamName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationTeamNameRequired;
    if (clean.length < 2) return AppStrings.validationTeamNameMinLength;
    if (clean.length > maxTeamNameLength) {
      return AppStrings.validationTeamNameMaxLength(maxTeamNameLength);
    }
    return null;
  }

  static String? inviteEmail(String? value) {
    final emailError = loginEmail(value);
    if (emailError != null) return AppStrings.validationInviteEmailInvalid;
    return null;
  }

  static String? projectName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationProjectNameRequired;
    if (clean.length < 2) return AppStrings.validationProjectNameMinLength;
    if (clean.length > maxProjectNameLength) {
      return AppStrings.validationProjectNameMaxLength(maxProjectNameLength);
    }
    return null;
  }

  static String? projectDescription(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationDescriptionRequired;
    if (clean.length < 10) return AppStrings.validationDescriptionMinLength;
    if (clean.length > maxDescriptionLength) {
      return AppStrings.validationDescriptionMaxLength(maxDescriptionLength);
    }
    return null;
  }

  static String? submissionPayload({
    required String teamId,
    required String name,
    required String githubUrl,
    required String videoUrl,
    required String description,
  }) {
    if (teamId.trim().isEmpty) {
      return AppStrings.validationJoinTeamBeforeSubmit;
    }
    return projectName(name) ??
        webUrl(githubUrl, label: AppStrings.githubUrlLabel) ??
        webUrl(videoUrl, label: AppStrings.demoVideoUrlLabel) ??
        projectDescription(description);
  }

  static String? chatMessage(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationChatMessageRequired;
    if (clean.length > maxChatMessageLength) {
      return AppStrings.validationChatMessageMaxLength(maxChatMessageLength);
    }
    return null;
  }

  static String? notificationTitle(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationNotificationTitleRequired;
    if (clean.length > maxNotificationTitleLength) {
      return AppStrings.validationNotificationTitleMaxLength(
        maxNotificationTitleLength,
      );
    }
    return null;
  }

  static String? notificationBody(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationNotificationBodyRequired;
    if (clean.length > maxNotificationContentLength) {
      return AppStrings.validationNotificationBodyMaxLength(
        maxNotificationContentLength,
      );
    }
    return null;
  }

  static String? notificationContent({
    required String title,
    required String content,
    required String type,
  }) {
    return notificationTitle(title) ??
        notificationBody(content) ??
        (!notificationTypes.contains(type)
            ? AppStrings.validationNotificationTypeInvalid
            : null);
  }

  static String? notificationPayload({
    required String? userId,
    required String title,
    required String content,
    required String type,
  }) {
    final userError = requireUserId(
      userId,
      label: AppStrings.validationRecipientLabel,
    );
    if (userError != null) return userError;
    return notificationContent(title: title, content: content, type: type);
  }

  static String? notificationRoute({
    required String type,
    required String role,
  }) {
    switch (type) {
      case 'score':
        if (role == AppRoles.participant) return AppRoutes.submit;
        if (role == AppRoles.judge) return AppRoutes.judge;
        if (role == AppRoles.organizer) return AppRoutes.organizer;
        return AppRoutes.teams;
      case 'invitation':
        return AppRoutes.teams;
      case 'reminder':
        return AppRoutes.map;
      case 'system':
        if (role == AppRoles.participant) return AppRoutes.submit;
        if (role == AppRoles.judge) return AppRoutes.judge;
        if (role == AppRoles.organizer) return AppRoutes.organizer;
        return AppRoutes.events;
      case 'announcement':
        return AppRoutes.events;
      default:
        return AppRoutes.events;
    }
  }

  static String? eventTitle(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationEventTitleRequired;
    if (clean.length < 2) return AppStrings.validationEventTitleMinLength;
    return null;
  }

  static String? eventLocation(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationEventLocationRequired;
    if (clean.length < 2) return AppStrings.validationEventLocationMinLength;
    return null;
  }

  static String? eventMaxTeamSize(int value) {
    if (value < minTeamSize || value > maxTeamSize) {
      return AppStrings.validationMaxTeamSizeRange(minTeamSize, maxTeamSize);
    }
    return null;
  }

  static const eventDateTimeFormat = 'yyyy-MM-dd HH:mm';

  static String? eventDateTimeField(String? value, {required String label}) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationFieldRequired(label);
    final parsed = DateFormat(eventDateTimeFormat).tryParseStrict(clean);
    if (parsed == null) {
      return AppStrings.validationDateTimeFormat(label, eventDateTimeFormat);
    }
    return null;
  }

  static DateTime? parseEventDateTime(String value) {
    return DateFormat(eventDateTimeFormat).tryParseStrict(value.trim());
  }

  static String? latitudeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationLatitudeRequired;
    final parsed = double.tryParse(clean);
    if (parsed == null) return AppStrings.validationLatitudeInvalid;
    if (parsed < -90 || parsed > 90) {
      return AppStrings.validationLatitudeRange;
    }
    return null;
  }

  static String? longitudeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationLongitudeRequired;
    final parsed = double.tryParse(clean);
    if (parsed == null) return AppStrings.validationLongitudeInvalid;
    if (parsed < -180 || parsed > 180) {
      return AppStrings.validationLongitudeRange;
    }
    return null;
  }

  static String? eventMaxTeamSizeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return AppStrings.validationMaxTeamSizeRequired;
    final parsed = int.tryParse(clean);
    if (parsed == null) {
      return AppStrings.validationMaxTeamSizeInvalid;
    }
    return eventMaxTeamSize(parsed);
  }

  static String? eventSchedule({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime registrationDeadline,
  }) {
    if (!endDate.isAfter(startDate)) {
      return AppStrings.validationEndAfterStart;
    }
    if (registrationDeadline.isAfter(endDate)) {
      return AppStrings.validationDeadlineBeforeEnd;
    }
    return null;
  }

  static String? coordinates({
    required double latitude,
    required double longitude,
  }) {
    if (latitude < -90 || latitude > 90) {
      return AppStrings.validationLatitudeRange;
    }
    if (longitude < -180 || longitude > 180) {
      return AppStrings.validationLongitudeRange;
    }
    return null;
  }

  static String? eventPayload({
    required String title,
    required String location,
    required String bannerUrl,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime registrationDeadline,
    required int maxTeamSize,
    required double latitude,
    required double longitude,
  }) {
    return eventTitle(title) ??
        eventLocation(location) ??
        optionalWebUrl(bannerUrl, label: AppStrings.validationBannerUrlLabel) ??
        eventMaxTeamSize(maxTeamSize) ??
        eventSchedule(
          startDate: startDate,
          endDate: endDate,
          registrationDeadline: registrationDeadline,
        ) ??
        coordinates(latitude: latitude, longitude: longitude);
  }

  static String? scoreError(double technical, double ui, double innovation) {
    final values = [technical, ui, innovation];
    final inRange = values.every((score) => score >= 0 && score <= 10);
    return inRange ? null : AppStrings.validationScoreRange;
  }

  static String? judgeScore({
    required String submissionId,
    required String judgeId,
    required double technical,
    required double ui,
    required double innovation,
    required String feedback,
  }) {
    if (submissionId.trim().isEmpty) {
      return AppStrings.validationNoSubmissionSelected;
    }
    if (judgeId.trim().isEmpty) {
      return AppStrings.validationInvalidJudgeSession;
    }
    final scoreValidation = scoreError(technical, ui, innovation);
    if (scoreValidation != null) return scoreValidation;
    final cleanFeedback = feedback.trim();
    if (cleanFeedback.isEmpty) return AppStrings.validationFeedbackRequired;
    if (cleanFeedback.length > maxDescriptionLength) {
      return AppStrings.validationFeedbackMaxLength(maxDescriptionLength);
    }
    return null;
  }

  static String? userRole(String? role) {
    const roles = {
      AppRoles.participant,
      AppRoles.judge,
      AppRoles.mentor,
      AppRoles.organizer,
    };
    if (role == null || !roles.contains(role)) {
      return AppStrings.validationInvalidRole;
    }
    return null;
  }
}

class AppLabels {
  const AppLabels._();

  static String submissionStatus(String status) {
    return switch (status) {
      'reviewed' => AppStrings.submissionStatusReviewed,
      'submitted' => AppStrings.submissionStatusSubmitted,
      'draft' => AppStrings.submissionStatusDraft,
      _ => status,
    };
  }
}

class AppOperation {
  const AppOperation._();

  static const timeout = Duration(seconds: 12);

  static Future<T> run<T>(
    String name,
    Future<T> Function() action, {
    int retries = 1,
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        final result = await action().timeout(timeout);
        AppLogger.info(name, {'attempt': attempt, 'status': 'success'});
        return result;
      } catch (exception) {
        AppLogger.error(name, exception, {'attempt': attempt});
        final retryable =
            exception is TimeoutException ||
            exception.toString().toLowerCase().contains('socket') ||
            exception.toString().toLowerCase().contains('connection');
        if (!retryable || attempt > retries) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 350 * attempt));
      }
    }
  }
}

class AppLogger {
  const AppLogger._();

  static void info(String event, [Map<String, Object?>? fields]) {
    debugPrint('[seal][info] $event ${_safeFields(fields)}');
  }

  static void action(String event, [Map<String, Object?>? fields]) {
    debugPrint('[seal][action] $event ${_safeFields(fields)}');
  }

  static void error(
    String event,
    Object exception, [
    Map<String, Object?>? fields,
  ]) {
    debugPrint(
      '[seal][error] $event ${_safeFields(fields)} message=${FriendlyErrorMapper.message(exception)}',
    );
  }

  static Map<String, Object?> _safeFields(Map<String, Object?>? fields) {
    if (fields == null) return const {};
    return {
      for (final entry in fields.entries)
        if (!_sensitiveKeys.contains(entry.key.toLowerCase()))
          entry.key: entry.value,
    };
  }

  static const _sensitiveKeys = {
    'password',
    'token',
    'apikey',
    'api_key',
    'anonkey',
    'anon_key',
    'servicerolekey',
    'service_role_key',
  };
}

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
    if (exception is AuthException) {
      final text = exception.message.toLowerCase();
      if (text.contains('invalid login credentials') ||
          text.contains('invalid_credentials')) {
        return AppStrings.errorInvalidCredentials;
      }
      if (text.contains('email not confirmed')) {
        return AppStrings.errorEmailNotConfirmed;
      }
      if (text.contains('otp') ||
          text.contains('verification token') ||
          text.contains('signup token')) {
        return AppStrings.errorInvalidOtp;
      }
      return _isTechnicalError(exception.message)
          ? AppStrings.unknownError
          : exception.message;
    }
    if (exception is TimeoutException) {
      return AppStrings.errorConnectionTimeout;
    }
    if (exception is PostgrestException) {
      final text = exception.message.toLowerCase();
      if (exception.code == '42501' || text.contains('row-level security')) {
        return AppStrings.errorRlsPermissionDenied;
      }
      if (exception.code == '23505') {
        if (text.contains('team_invitations')) {
          return AppStrings.invitationAlreadyPending;
        }
        return AppStrings.errorDuplicateRecord;
      }
      if (exception.code == '23514') {
        return AppStrings.errorCheckConstraint;
      }
      if (text.contains('already on a team for this event')) {
        return AppStrings.alreadyOnEventTeamError;
      }
      return AppStrings.unknownError;
    }
    final text = exception.toString();
    if (text.contains('PostgrestException')) {
      return AppStrings.unknownError;
    }
    final clean = text.replaceFirst('Exception: ', '').trim();
    if (_isTechnicalError(clean)) return AppStrings.unknownError;
    return clean;
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

class ExternalLauncher {
  const ExternalLauncher._();

  static const _channel = MethodChannel('vn.seal.hackathon/external');

  static Future<bool> openUrl(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return false;
    try {
      return await _channel.invokeMethod<bool>('openUrl', value) ?? false;
    } on MissingPluginException {
      return false;
    }
  }
}
