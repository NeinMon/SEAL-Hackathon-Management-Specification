part of '../main.dart';

class ScoreProvider extends ChangeNotifier {
  final ScoreService _service = const ScoreService();
  List<ProjectScore> scores = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadScores() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      scores = await _service.fetchScores();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addScore(ProjectScore score) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    try {
      await _service.createScore(score);
      await loadScores();
      message = 'Score saved successfully.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  double averageFor(String submissionId) {
    final related = scores
        .where((score) => score.submissionId == submissionId)
        .toList();
    if (related.isEmpty) return 0;
    return related.map((score) => score.average).reduce((a, b) => a + b) /
        related.length;
  }

  int scoreCountFor(String submissionId) {
    return scores.where((score) => score.submissionId == submissionId).length;
  }

  ProjectScore? scoreFor(String submissionId, String judgeId) {
    for (final score in scores) {
      if (score.submissionId == submissionId && score.judgeId == judgeId) {
        return score;
      }
    }
    return null;
  }

  void clear() {
    scores = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
