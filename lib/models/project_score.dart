import 'score_criterion.dart';

class ProjectScore {
  const ProjectScore({
    required this.submissionId,
    required this.judgeId,
    required this.technicalScore,
    required this.uiScore,
    required this.innovationScore,
    required this.feedback,
    this.criteriaScores = const {},
    this.averageScore,
  });

  final String submissionId;
  final String judgeId;
  final double technicalScore;
  final double uiScore;
  final double innovationScore;
  final String feedback;
  final Map<String, double> criteriaScores;
  final double? averageScore;

  double averageFor(List<ScoreCriterion> criteria) {
    if (criteriaScores.isNotEmpty) {
      return ScoreCriterion.weightedAverage(criteriaScores, criteria);
    }
    return (technicalScore + uiScore + innovationScore) / 3;
  }

  double get average {
    if (averageScore != null) return averageScore!;
    if (criteriaScores.isNotEmpty) {
      return ScoreCriterion.weightedAverage(
        criteriaScores,
        ScoreCriterion.defaultCriteria,
      );
    }
    return (technicalScore + uiScore + innovationScore) / 3;
  }

  ProjectScore withPersistedAverage(List<ScoreCriterion> criteria) {
    return ProjectScore(
      submissionId: submissionId,
      judgeId: judgeId,
      technicalScore: technicalScore,
      uiScore: uiScore,
      innovationScore: innovationScore,
      feedback: feedback,
      criteriaScores: criteriaScores,
      averageScore: averageFor(criteria),
    );
  }

  factory ProjectScore.fromJson(Map<String, dynamic> json) {
    final rawCriteria = json['criteria_scores'];
    final criteriaScores = <String, double>{};
    if (rawCriteria is Map) {
      for (final entry in rawCriteria.entries) {
        final value = entry.value;
        if (value is num) {
          criteriaScores[entry.key.toString()] = value.toDouble();
        }
      }
    }
    final rawAverage = json['average_score'];
    return ProjectScore(
      submissionId: (json['submission_id'] ?? '') as String,
      judgeId: (json['judge_id'] ?? '') as String,
      technicalScore: ((json['technical_score'] ?? 0) as num).toDouble(),
      uiScore: ((json['ui_score'] ?? 0) as num).toDouble(),
      innovationScore: ((json['innovation_score'] ?? 0) as num).toDouble(),
      feedback: (json['feedback'] ?? '') as String,
      criteriaScores: criteriaScores,
      averageScore: rawAverage is num ? rawAverage.toDouble() : null,
    );
  }
}
