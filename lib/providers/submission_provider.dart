import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../models/project_submission.dart';
import '../services/supabase_services.dart';

class SubmissionProvider extends ChangeNotifier {
  final SubmissionService _service = const SubmissionService();
  List<ProjectSubmission> submissions = [];
  List<SubmissionHistory> history = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadSubmissions() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      submissions = await _service.fetchSubmissions();
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
  }) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    try {
      await _service.saveSubmission(
        submission,
        existingSubmissionId: existingSubmissionId,
      );
      await loadSubmissions();
      message = existingSubmissionId == null
          ? 'Đã nộp project.'
          : 'Đã cập nhật bài nộp.';
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
