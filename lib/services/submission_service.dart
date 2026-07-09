import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/project_submission.dart';

class SubmissionService {
  const SubmissionService();

  Future<List<ProjectSubmission>> fetchSubmissions({String? eventId}) async {
    return AppOperation.run('submissions.fetch', () async {
      if (eventId != null && eventId.isNotEmpty) {
        final teamRows = await SupabaseGateway.client
            .from('teams')
            .select('id')
            .eq('event_id', eventId);
        final teamIds = teamRows
            .whereType<Map<String, dynamic>>()
            .map((row) => (row['id'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toList();
        if (teamIds.isEmpty) return [];
        final rows = await SupabaseGateway.client
            .from('submissions')
            .select()
            .inFilter('team_id', teamIds)
            .order('submitted_at', ascending: false);
        return rows
            .whereType<Map<String, dynamic>>()
            .map(ProjectSubmission.fromJson)
            .toList();
      }
      final rows = await SupabaseGateway.client
          .from('submissions')
          .select()
          .order('submitted_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ProjectSubmission.fromJson)
          .toList();
    });
  }

  Future<void> saveSubmission(
    ProjectSubmission submission, {
    String? existingSubmissionId,
  }) {
    final payload = {
      'team_id': submission.teamId,
      'github_url': submission.githubUrl,
      'video_url': submission.videoUrl,
      'project_name': submission.projectName,
      'description': submission.description,
      'status': submission.status,
    };
    AppLogger.action('submission.save', {
      'submission_id': existingSubmissionId ?? submission.id,
      'team_id': submission.teamId,
      'status': submission.status,
      'mode': existingSubmissionId == null ? 'create' : 'update',
    });
    return AppOperation.run('submissions.save', () {
      if (existingSubmissionId != null) {
        return SupabaseGateway.client
            .from('submissions')
            .update(payload)
            .eq('id', existingSubmissionId);
      }
      return SupabaseGateway.client.from('submissions').insert(payload);
    });
  }

  Future<List<SubmissionHistory>> fetchHistory() {
    return AppOperation.run('submission_history.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('submission_history')
          .select()
          .order('changed_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(SubmissionHistory.fromJson)
          .toList();
    });
  }
}
