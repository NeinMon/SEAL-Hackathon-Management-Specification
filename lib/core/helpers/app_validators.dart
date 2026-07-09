import '../l10n/l10n_service.dart';
import 'package:intl/intl.dart';

import '../constants/app_routes.dart';
import '../supabase_config.dart';
import 'app_roles.dart';
import '../../models/score_criterion.dart';

class AppValidators {
  const AppValidators._();

  static const maxEventSearchLength = 80;
  static const maxTeamNameLength = 60;
  static const maxProjectNameLength = 80;
  static const maxDescriptionLength = 2000;
  static const maxChatMessageLength = 1000;
  static const maxNotificationTitleLength = 120;
  static const maxNotificationContentLength = 500;
  static const maxScoreCriteria = 8;
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
    if (clean.isEmpty) return L10nService.strings.validationEmailRequired;
    if (!isValidEmail(clean)) return L10nService.strings.validationEmailInvalid;
    return null;
  }

  static String? loginPassword(String? value) {
    final raw = value ?? '';
    if (raw.isEmpty) return L10nService.strings.validationPasswordRequired;
    if (raw.length < 6) return L10nService.strings.validationPasswordMinLength;
    return null;
  }

  static String? confirmPassword(String? password, String? confirm) {
    if ((confirm ?? '').isEmpty) {
      return L10nService.strings.validationConfirmPasswordRequired;
    }
    final passwordError = loginPassword(password);
    if (passwordError != null) return passwordError;
    if (password != confirm) return L10nService.strings.validationPasswordMismatch;
    return null;
  }

  static String? signupOtp(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationOtpRequired;
    if (!RegExp(r'^\d{6}$').hasMatch(clean)) {
      return L10nService.strings.validationOtpInvalid;
    }
    return null;
  }

  static String? registerName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationFullNameRequired;
    if (clean.length < 2) return L10nService.strings.validationFullNameMinLength;
    return null;
  }

  static String? registerUniversity(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationUniversityRequired;
    if (clean.length < 2) return L10nService.strings.validationUniversityMinLength;
    return null;
  }

  static String? eventSearchQuery(String value) {
    if (value.trim().length > maxEventSearchLength) {
      return L10nService.strings.validationSearchMaxLength(maxEventSearchLength);
    }
    return null;
  }

  static String? requireSupabaseReady() {
    if (!SupabaseGateway.isReady) {
      return L10nService.strings.validationSupabaseNotReady;
    }
    return null;
  }

  static String? requireUserId(String? userId, {String? label}) {
    final resolvedLabel = label ?? L10nService.strings.validationUserLabel;
    if (userId == null || userId.trim().isEmpty) {
      return L10nService.strings.validationInvalidUser(resolvedLabel);
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
    if (clean.isEmpty) return L10nService.strings.validationFieldRequired(label);
    if (!isValidWebUrl(clean)) return L10nService.strings.validationInvalidUrl(label);
    return null;
  }

  static String? optionalWebUrl(String? value, {required String label}) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return null;
    if (!isValidWebUrl(clean)) return L10nService.strings.validationInvalidUrl(label);
    return null;
  }

  static String? teamName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationTeamNameRequired;
    if (clean.length < 2) return L10nService.strings.validationTeamNameMinLength;
    if (clean.length > maxTeamNameLength) {
      return L10nService.strings.validationTeamNameMaxLength(maxTeamNameLength);
    }
    return null;
  }

  static String? inviteEmail(String? value) {
    final emailError = loginEmail(value);
    if (emailError != null) return L10nService.strings.validationInviteEmailInvalid;
    return null;
  }

  static String? projectName(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationProjectNameRequired;
    if (clean.length < 2) return L10nService.strings.validationProjectNameMinLength;
    if (clean.length > maxProjectNameLength) {
      return L10nService.strings.validationProjectNameMaxLength(maxProjectNameLength);
    }
    return null;
  }

  static String? projectDescription(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationDescriptionRequired;
    if (clean.length < 10) return L10nService.strings.validationDescriptionMinLength;
    if (clean.length > maxDescriptionLength) {
      return L10nService.strings.validationDescriptionMaxLength(maxDescriptionLength);
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
      return L10nService.strings.validationJoinTeamBeforeSubmit;
    }
    return projectName(name) ??
        webUrl(githubUrl, label: L10nService.strings.githubUrlLabel) ??
        webUrl(videoUrl, label: L10nService.strings.demoVideoUrlLabel) ??
        projectDescription(description);
  }

  static String? chatMessage(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationChatMessageRequired;
    if (clean.length > maxChatMessageLength) {
      return L10nService.strings.validationChatMessageMaxLength(maxChatMessageLength);
    }
    return null;
  }

  static String? notificationTitle(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationNotificationTitleRequired;
    if (clean.length > maxNotificationTitleLength) {
      return L10nService.strings.validationNotificationTitleMaxLength(
        maxNotificationTitleLength,
      );
    }
    return null;
  }

  static String? notificationBody(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationNotificationBodyRequired;
    if (clean.length > maxNotificationContentLength) {
      return L10nService.strings.validationNotificationBodyMaxLength(
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
            ? L10nService.strings.validationNotificationTypeInvalid
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
      label: L10nService.strings.validationRecipientLabel,
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
    if (clean.isEmpty) return L10nService.strings.validationEventTitleRequired;
    if (clean.length < 2) return L10nService.strings.validationEventTitleMinLength;
    return null;
  }

  static String? eventLocation(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationEventLocationRequired;
    if (clean.length < 2) return L10nService.strings.validationEventLocationMinLength;
    return null;
  }

  static String? eventMaxTeamSize(int value) {
    if (value < minTeamSize || value > maxTeamSize) {
      return L10nService.strings.validationMaxTeamSizeRange(minTeamSize, maxTeamSize);
    }
    return null;
  }

  static const eventDateTimeFormat = 'yyyy-MM-dd HH:mm';

  static String? eventDateTimeField(String? value, {required String label}) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationFieldRequired(label);
    final parsed = DateFormat(eventDateTimeFormat).tryParseStrict(clean);
    if (parsed == null) {
      return L10nService.strings.validationDateTimeFormat(label, eventDateTimeFormat);
    }
    return null;
  }

  static DateTime? parseEventDateTime(String value) {
    return DateFormat(eventDateTimeFormat).tryParseStrict(value.trim());
  }

  static String? latitudeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationLatitudeRequired;
    final parsed = double.tryParse(clean);
    if (parsed == null) return L10nService.strings.validationLatitudeInvalid;
    if (parsed < -90 || parsed > 90) {
      return L10nService.strings.validationLatitudeRange;
    }
    return null;
  }

  static String? longitudeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationLongitudeRequired;
    final parsed = double.tryParse(clean);
    if (parsed == null) return L10nService.strings.validationLongitudeInvalid;
    if (parsed < -180 || parsed > 180) {
      return L10nService.strings.validationLongitudeRange;
    }
    return null;
  }

  static String? eventMaxTeamSizeField(String? value) {
    final clean = (value ?? '').trim();
    if (clean.isEmpty) return L10nService.strings.validationMaxTeamSizeRequired;
    final parsed = int.tryParse(clean);
    if (parsed == null) {
      return L10nService.strings.validationMaxTeamSizeInvalid;
    }
    return eventMaxTeamSize(parsed);
  }

  static String? eventSchedule({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime registrationDeadline,
    DateTime? submissionDeadline,
  }) {
    if (!endDate.isAfter(startDate)) {
      return L10nService.strings.validationEndAfterStart;
    }
    if (registrationDeadline.isAfter(endDate)) {
      return L10nService.strings.validationDeadlineBeforeEnd;
    }
    final submission = submissionDeadline;
    if (submission != null) {
      if (!submission.isAfter(startDate)) {
        return L10nService.strings.validationSubmissionAfterStart;
      }
      if (submission.isAfter(endDate)) {
        return L10nService.strings.validationSubmissionBeforeEnd;
      }
    }
    return null;
  }

  static String? coordinates({
    required double latitude,
    required double longitude,
  }) {
    if (latitude < -90 || latitude > 90) {
      return L10nService.strings.validationLatitudeRange;
    }
    if (longitude < -180 || longitude > 180) {
      return L10nService.strings.validationLongitudeRange;
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
    DateTime? submissionDeadline,
  }) {
    return eventTitle(title) ??
        eventLocation(location) ??
        optionalWebUrl(bannerUrl, label: L10nService.strings.validationBannerUrlLabel) ??
        eventMaxTeamSize(maxTeamSize) ??
        eventSchedule(
          startDate: startDate,
          endDate: endDate,
          registrationDeadline: registrationDeadline,
          submissionDeadline: submissionDeadline,
        ) ??
        coordinates(latitude: latitude, longitude: longitude);
  }

  static String? scoreError(double technical, double ui, double innovation) {
    final values = [technical, ui, innovation];
    final inRange = values.every((score) => score >= 0 && score <= 10);
    return inRange ? null : L10nService.strings.validationScoreRange;
  }

  static String? scoreValues(Iterable<double> values) {
    final list = values.toList();
    if (list.isEmpty) return L10nService.strings.validationScoreCriteriaRequired;
    final inRange = list.every((score) => score >= 0 && score <= 10);
    return inRange ? null : L10nService.strings.validationScoreRange;
  }

  static String? scoreCriteria(List<ScoreCriterion> criteria) {
    if (criteria.isEmpty) return L10nService.strings.validationScoreCriteriaRequired;
    if (criteria.length > maxScoreCriteria) {
      return L10nService.strings.validationScoreCriteriaLimit;
    }
    final ids = <String>{};
    for (final item in criteria) {
      if (item.label.trim().isEmpty) {
        return L10nService.strings.validationScoreCriteriaLabelRequired;
      }
      if (item.weight <= 0) return L10nService.strings.validationScoreCriteriaWeight;
      if (!ids.add(item.id)) return L10nService.strings.validationScoreCriteriaDuplicate;
    }
    return null;
  }

  static String? judgeScore({
    required String submissionId,
    required String judgeId,
    required double technical,
    required double ui,
    required double innovation,
    required String feedback,
    Map<String, double> criteriaScores = const {},
  }) {
    if (submissionId.trim().isEmpty) {
      return L10nService.strings.validationNoSubmissionSelected;
    }
    if (judgeId.trim().isEmpty) {
      return L10nService.strings.validationInvalidJudgeSession;
    }
    final scoreValidation = criteriaScores.isEmpty
        ? scoreError(technical, ui, innovation)
        : scoreValues(criteriaScores.values);
    if (scoreValidation != null) return scoreValidation;
    final cleanFeedback = feedback.trim();
    if (cleanFeedback.isEmpty) return L10nService.strings.validationFeedbackRequired;
    if (cleanFeedback.length > maxDescriptionLength) {
      return L10nService.strings.validationFeedbackMaxLength(maxDescriptionLength);
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
      return L10nService.strings.validationInvalidRole;
    }
    return null;
  }
}
