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
      error = exception.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> submit(ProjectSubmission submission) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    try {
      await _service.createSubmission(submission);
      await loadSubmissions();
      message = 'Project submitted successfully.';
    } catch (exception) {
      error = exception.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
