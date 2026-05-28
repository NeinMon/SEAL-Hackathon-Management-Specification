part of '../main.dart';

class ProjectSubmission {
  ProjectSubmission({
    required this.id,
    required this.teamId,
    required this.projectName,
    required this.githubUrl,
    required this.videoUrl,
    required this.description,
    this.status = 'submitted',
  });

  final String id;
  final String teamId;
  final String projectName;
  final String githubUrl;
  final String videoUrl;
  final String description;
  final String status;

  factory ProjectSubmission.fromJson(Map<String, dynamic> json) {
    return ProjectSubmission(
      id: json['id'] as String,
      teamId: (json['team_id'] ?? '') as String,
      projectName: (json['project_name'] ?? '') as String,
      githubUrl: (json['github_url'] ?? '') as String,
      videoUrl: (json['video_url'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      status: (json['status'] ?? 'submitted') as String,
    );
  }
}
