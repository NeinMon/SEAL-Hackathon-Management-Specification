class ProjectSubmission {
  ProjectSubmission({
    required this.id,
    required this.teamId,
    required this.projectName,
    required this.githubUrl,
    required this.videoUrl,
    required this.description,
    this.status = 'submitted',
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  final String id;
  final String teamId;
  final String projectName;
  final String githubUrl;
  final String videoUrl;
  final String description;
  final String status;
  final DateTime submittedAt;

  factory ProjectSubmission.fromJson(Map<String, dynamic> json) {
    return ProjectSubmission(
      id: json['id'] as String,
      teamId: (json['team_id'] ?? '') as String,
      projectName: (json['project_name'] ?? '') as String,
      githubUrl: (json['github_url'] ?? '') as String,
      videoUrl: (json['video_url'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      status: (json['status'] ?? 'submitted') as String,
      submittedAt:
          DateTime.tryParse((json['submitted_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}

class SubmissionHistory {
  const SubmissionHistory({
    required this.id,
    required this.submissionId,
    required this.status,
    required this.projectName,
    required this.changedAt,
  });

  final String id;
  final String submissionId;
  final String status;
  final String projectName;
  final DateTime changedAt;

  factory SubmissionHistory.fromJson(Map<String, dynamic> json) {
    return SubmissionHistory(
      id: (json['id'] ?? '') as String,
      submissionId: (json['submission_id'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      projectName: (json['project_name'] ?? '') as String,
      changedAt:
          DateTime.tryParse((json['changed_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
