part of '../main.dart';

class SubmissionProvider extends ChangeNotifier {
  final SubmissionService _service = const SubmissionService();
  List<ProjectSubmission> submissions = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadSubmissions() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      submissions = await _service.fetchSubmissions();
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
          ? 'Project submitted successfully.'
          : 'Project submission updated successfully.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void clear() {
    submissions = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
