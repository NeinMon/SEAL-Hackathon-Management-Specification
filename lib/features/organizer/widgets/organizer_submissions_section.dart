import '../../../shared.dart';

class OrganizerSubmissionsSection extends StatelessWidget {
  const OrganizerSubmissionsSection({
    super.key,
    required this.submissions,
    required this.scores,
    required this.teams,
    required this.onTapSubmission,
  });

  final SubmissionProvider submissions;
  final ScoreProvider scores;
  final TeamProvider teams;
  final void Function(ProjectSubmission submission) onTapSubmission;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          AppStrings.recentSubmissionsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (submissions.submissions.isEmpty)
          EmptyState(
            message: AppStrings.noSubmissionsYet,
            icon: Icons.assignment_outlined,
            actionLabel: AppStrings.openTeamAction,
            onAction: () => context.go(AppRoutes.teams),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: submissions.submissions.take(5).length,
            itemBuilder: (context, index) {
              final submission = submissions.submissions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in_outlined),
                  title: Text(submission.projectName),
                  subtitle: Text(
                    '${AppLabels.submissionStatus(submission.status)} - ${AppStrings.scoreCountLabel(scores.scoreCountFor(submission.id))}',
                  ),
                  trailing: Text(
                    scores.averageFor(submission.id).toStringAsFixed(1),
                    style: const TextStyle(
                      color: SealPalette.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => onTapSubmission(submission),
                ),
              );
            },
          ),
      ],
    );
  }
}
