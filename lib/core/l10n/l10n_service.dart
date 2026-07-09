import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Resolves localized strings outside [BuildContext] (providers, validators).
class L10nService {
  L10nService._();

  static Locale _locale = const Locale('vi');

  static Locale get locale => _locale;

  static AppLocalizations get strings => lookupAppLocalizations(_locale);

  static void setLocale(Locale locale) {
    _locale = locale;
  }
}

extension L10nBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Helpers for localized strings that need extra formatting logic.
extension AppLocalizationsX on AppLocalizations {
  String memberCountWithLimitLabel(int current, int limit) {
    if (limit > 0) {
      return memberCountWithLimit(current, limit);
    }
    return memberCountLabel(current);
  }

  String scorePublishedNotificationBody(
    String projectName, {
    double? average,
    String? feedback,
  }) {
    final buffer = StringBuffer(projectName);
    if (localeName.startsWith('vi')) {
      buffer.write(' có điểm mới');
      if (average != null) {
        buffer.write(': ${average.toStringAsFixed(1)} điểm');
      }
      if (feedback != null && feedback.trim().isNotEmpty) {
        buffer.write('. Nhận xét: ${feedback.trim()}');
      }
      buffer.write('.');
      return buffer.toString();
    }
    if (localeName.startsWith('ja')) {
      buffer.write('に新しいスコアがあります');
      if (average != null) {
        buffer.write('：${average.toStringAsFixed(1)}点');
      }
      if (feedback != null && feedback.trim().isNotEmpty) {
        buffer.write('。フィードバック：${feedback.trim()}');
      }
      buffer.write('。');
      return buffer.toString();
    }
    buffer.write(' has a new score');
    if (average != null) {
      buffer.write(': ${average.toStringAsFixed(1)} points');
    }
    if (feedback != null && feedback.trim().isNotEmpty) {
      buffer.write('. Feedback: ${feedback.trim()}');
    }
    buffer.write('.');
    return buffer.toString();
  }

  String journeyScoreSummaryFormatted(double score) {
    return journeyScoreSummary(score.toStringAsFixed(1));
  }

  String teamSemanticLabelFor(
    String name,
    int memberCount,
    String leader,
  ) {
    return teamSemanticLabel(
      name,
      memberCountLabel(memberCount),
      leaderPrefix(leader),
    );
  }
}
