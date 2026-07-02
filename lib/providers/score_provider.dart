import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../models/hackathon_event.dart';
import '../models/project_score.dart';
import '../services/supabase_services.dart';

class ScoreProvider extends ChangeNotifier {
  final ScoreService _service = const ScoreService();
  List<ProjectScore> scores = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadScores() async {
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
      scores = await _service.fetchScores();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addScore(ProjectScore score, {HackathonEvent? event}) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    if (event != null) {
      final lifecycleError = event.judgingBlockReason();
      if (lifecycleError != null) {
        error = lifecycleError;
        isLoading = false;
        notifyListeners();
        return;
      }
    }
    final validationError = AppValidators.judgeScore(
      submissionId: score.submissionId,
      judgeId: score.judgeId,
      technical: score.technicalScore,
      ui: score.uiScore,
      innovation: score.innovationScore,
      feedback: score.feedback,
    );
    if (validationError != null) {
      error = validationError;
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
      await _service.createScore(score);
      await loadScores();
      message = AppStrings.scoreSavedSuccess;
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

  List<ProjectScore> scoresFor(String submissionId) {
    return scores.where((score) => score.submissionId == submissionId).toList();
  }

  void clear() {
    scores = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
