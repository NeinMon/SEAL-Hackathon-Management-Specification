import '../../../shared.dart';
import 'organizer_submission_tile.dart';

class OrganizerSubmissionsSection extends StatelessWidget {
  const OrganizerSubmissionsSection({
    super.key,
    required this.submissions,
    required this.scores,
    required this.teams,
    required this.onTapSubmission,
    this.focusEventId,
  });

  final SubmissionProvider submissions;
  final ScoreProvider scores;
  final TeamProvider teams;
  final void Function(ProjectSubmission submission) onTapSubmission;
  final String? focusEventId;

  List<ProjectSubmission> get _visibleSubmissions {
    if (focusEventId == null) return submissions.submissions;
    return EventScope.submissionsForEvent(
      submissions: submissions.submissions,
      teams: teams.teams,
      eventId: focusEventId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleSubmissions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          L10nService.strings.recentSubmissionsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          EmptyState(
            message: L10nService.strings.noSubmissionsYet,
            icon: Icons.assignment_outlined,
            actionLabel: L10nService.strings.openTeamAction,
            onAction: () => context.go(AppRoutes.teams),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.take(5).length,
            itemBuilder: (context, index) {
              final submission = visible[index];
              return OrganizerSubmissionTile(
                submission: submission,
                subtitle:
                    '${AppLabels.submissionStatus(submission.status)} - ${L10nService.strings.scoreCountLabel(scores.scoreCountFor(submission.id))}',
                averageLabel: scores.averageFor(submission.id).toStringAsFixed(1),
                onTap: () => onTapSubmission(submission),
              );
            },
          ),
      ],
    );
  }
}
