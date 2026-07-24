import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';

class JudgeQueueList extends StatelessWidget {
  const JudgeQueueList({
    super.key,
    required this.submissions,
    required this.scores,
    required this.teams,
    required this.events,
    required this.showEventContext,
    required this.onSubmissionTap,
  });

  final List<ProjectSubmission> submissions;
  final ScoreProvider scores;
  final List<Team> teams;
  final List<HackathonEvent> events;
  final bool showEventContext;
  final ValueChanged<ProjectSubmission> onSubmissionTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      itemCount: submissions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final submission = submissions[index];
        final scored = scores.scoreCountFor(submission.id) > 0;
        final teamName = JudgeQueueViewData.teamNameFor(
          submission.teamId,
          teams,
        );
        final subtitle = _subtitle(submission, teamName);
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor: scored
                  ? context.sealSecondaryContainer
                  : context.sealTertiary.withValues(alpha: 0.18),
              child: Icon(
                scored
                    ? Icons.verified_outlined
                    : Icons.pending_actions_outlined,
                color: scored ? context.sealSecondary : context.sealTertiary,
              ),
            ),
            title: Text(
              submission.projectName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: scored
                ? StatusPill(
                    label: scores
                        .averageFor(submission.id)
                        .toStringAsFixed(1),
                    color: context.sealSecondary,
                    icon: Icons.leaderboard_outlined,
                  )
                : Icon(
                    Icons.chevron_right,
                    color: context.sealTheme.onSurfaceVariant,
                  ),
            onTap: () => onSubmissionTap(submission),
          ),
        );
      },
    );
  }

  String _subtitle(ProjectSubmission submission, String teamName) {
    if (!showEventContext) return teamName;
    final eventTitle = EventScope.eventTitleForSubmission(
      submission: submission,
      teams: teams,
      events: events,
    );
    if (eventTitle == null) return teamName;
    return '$teamName • $eventTitle';
  }
}
