import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/project_score.dart';
import '../models/score_criterion.dart';

class ScoreService {
  const ScoreService();

  Future<List<ProjectScore>> fetchScores({String? eventId}) async {
    return AppOperation.run('scores.fetch', () async {
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
        final submissionRows = await SupabaseGateway.client
            .from('submissions')
            .select('id')
            .inFilter('team_id', teamIds);
        final submissionIds = submissionRows
            .whereType<Map<String, dynamic>>()
            .map((row) => (row['id'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toList();
        if (submissionIds.isEmpty) return [];
        final rows = await SupabaseGateway.client
            .from('scores')
            .select()
            .inFilter('submission_id', submissionIds);
        return rows
            .whereType<Map<String, dynamic>>()
            .map(ProjectScore.fromJson)
            .toList();
      }
      final rows = await SupabaseGateway.client.from('scores').select();
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ProjectScore.fromJson)
          .toList();
    });
  }

  Future<List<ScoreCriterion>> fetchCriteria() async {
    return AppOperation.run('score_criteria.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('score_criteria')
          .select()
          .order('sort_order');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ScoreCriterion.fromJson)
          .toList();
    });
  }

  Future<void> saveCriteria({
    required String eventId,
    required List<ScoreCriterion> criteria,
  }) {
    AppLogger.action('score_criteria.save', {
      'event_id': eventId,
      'count': criteria.length,
    });
    return AppOperation.run('score_criteria.save', () async {
      await SupabaseGateway.client
          .from('score_criteria')
          .delete()
          .eq('event_id', eventId);
      await SupabaseGateway.client.from('score_criteria').insert([
        for (var index = 0; index < criteria.length; index++)
          criteria[index].toJson(eventId: eventId, order: index),
      ]);
    });
  }

  Future<void> createScore(ProjectScore score) {
    AppLogger.action('score.upsert', {
      'submission_id': score.submissionId,
      'judge_id': score.judgeId,
      'average': score.average,
    });
    return AppOperation.run('scores.upsert', () {
      return SupabaseGateway.client.from('scores').upsert({
        'submission_id': score.submissionId,
        'judge_id': score.judgeId,
        'technical_score': score.technicalScore,
        'ui_score': score.uiScore,
        'innovation_score': score.innovationScore,
        'criteria_scores': score.criteriaScores,
        'feedback': score.feedback,
        'average_score': score.average,
      }, onConflict: 'submission_id,judge_id');
    });
  }
}
