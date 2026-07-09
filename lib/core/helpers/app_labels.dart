import '../l10n/l10n_service.dart';
class AppLabels {
  const AppLabels._();

  static String submissionStatus(String status) {
    return switch (status) {
      'reviewed' => L10nService.strings.submissionStatusReviewed,
      'submitted' => L10nService.strings.submissionStatusSubmitted,
      'draft' => L10nService.strings.submissionStatusDraft,
      _ => status,
    };
  }
}
