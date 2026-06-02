class ProjectScore {
  const ProjectScore({
    required this.submissionId,
    required this.judgeId,
    required this.technicalScore,
    required this.uiScore,
    required this.innovationScore,
    required this.feedback,
  });

  final String submissionId;
  final String judgeId;
  final double technicalScore;
  final double uiScore;
  final double innovationScore;
  final String feedback;

  double get average => (technicalScore + uiScore + innovationScore) / 3;

  factory ProjectScore.fromJson(Map<String, dynamic> json) {
    return ProjectScore(
      submissionId: (json['submission_id'] ?? '') as String,
      judgeId: (json['judge_id'] ?? '') as String,
      technicalScore: ((json['technical_score'] ?? 0) as num).toDouble(),
      uiScore: ((json['ui_score'] ?? 0) as num).toDouble(),
      innovationScore: ((json['innovation_score'] ?? 0) as num).toDouble(),
      feedback: (json['feedback'] ?? '') as String,
    );
  }
}
