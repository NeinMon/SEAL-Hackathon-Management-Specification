import '../core/l10n/l10n_service.dart';
import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../models/hackathon_event.dart';
import '../models/project_score.dart';
import '../models/score_criterion.dart';
import '../services/supabase_services.dart';

class ScoreProvider extends ChangeNotifier {
  final ScoreService _service = const ScoreService();
  List<ProjectScore> scores = [];
  List<ScoreCriterion> criteria = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadScores({String? eventId}) async {
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
      scores = await _service.fetchScores(eventId: eventId);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadCriteria() async {
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
      criteria = await _service.fetchCriteria();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> saveCriteria({
    required String eventId,
    required List<ScoreCriterion> criteria,
  }) async {
    error = null;
    message = null;
    final validationError = AppValidators.scoreCriteria(criteria);
    if (validationError != null) {
      error = validationError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.saveCriteria(eventId: eventId, criteria: criteria);
      await loadCriteria();
      message = L10nService.strings.scoreCriteriaSavedSuccess;
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
    final validationError = AppValidators.judgeScore(
      submissionId: score.submissionId,
      judgeId: score.judgeId,
      technical: score.technicalScore,
      ui: score.uiScore,
      innovation: score.innovationScore,
      feedback: score.feedback,
      criteriaScores: score.criteriaScores,
    );
    if (validationError != null) {
      error = validationError;
      isLoading = false;
      notifyListeners();
      return;
    }
    if (event == null) {
      error = L10nService.strings.errorEventContextRequired;
      isLoading = false;
      notifyListeners();
      return;
    }
    final lifecycleError = event.judgingBlockReason();
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
      final criteriaList = criteriaForEvent(event.id);
      await _service.createScore(score.withPersistedAverage(criteriaList));
      await loadScores(eventId: event.id);
      message = L10nService.strings.scoreSavedSuccess;
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

  List<ScoreCriterion> criteriaForEvent(String? eventId) {
    if (eventId == null || eventId.trim().isEmpty) {
      return ScoreCriterion.defaultCriteria;
    }
    final eventCriteria =
        criteria.where((item) => item.eventId == eventId).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return eventCriteria.isEmpty
        ? ScoreCriterion.defaultCriteria
        : eventCriteria;
  }

  void clear() {
    scores = [];
    criteria = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
