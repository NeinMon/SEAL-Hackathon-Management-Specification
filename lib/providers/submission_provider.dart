import '../core/l10n/l10n_service.dart';
import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../core/helpers/workspace_catalog.dart';
import '../models/hackathon_event.dart';
import '../models/project_submission.dart';
import '../services/supabase_services.dart';

class SubmissionProvider extends ChangeNotifier {
  final SubmissionService _service = const SubmissionService();
  List<ProjectSubmission> submissions = [];
  List<SubmissionHistory> history = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadSubmissions({String? eventId}) async {
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      submissions = await _service.fetchSubmissions(eventId: eventId);
      history = await _service.fetchHistory();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> submit(
    ProjectSubmission submission, {
    String? existingSubmissionId,
    HackathonEvent? event,
  }) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    final validationError = AppValidators.submissionPayload(
      teamId: submission.teamId,
      name: submission.projectName,
      githubUrl: submission.githubUrl,
      videoUrl: submission.videoUrl,
      description: submission.description,
    );
    if (validationError != null) {
      error = validationError;
      isLoading = false;
      notifyListeners();
      return;
    }
    final resolvedEvent =
        event ?? WorkspaceCatalog.eventForTeamId(submission.teamId);
    if (resolvedEvent == null) {
      error = L10nService.strings.errorEventContextRequired;
      isLoading = false;
      notifyListeners();
      return;
    }
    final lifecycleError = resolvedEvent.submissionBlockReason();
    if (lifecycleError != null) {
      error = lifecycleError;
      isLoading = false;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      isLoading = false;
      notifyListeners();
      return;
    }
    try {
      await _service.saveSubmission(
        submission,
        existingSubmissionId: existingSubmissionId,
      );
      await loadSubmissions();
      message = existingSubmissionId == null
          ? L10nService.strings.submissionCreatedSuccess
          : L10nService.strings.submissionUpdatedSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void clear() {
    submissions = [];
    history = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }

  List<SubmissionHistory> historyFor(String submissionId) {
    return history.where((item) => item.submissionId == submissionId).toList();
  }
}
