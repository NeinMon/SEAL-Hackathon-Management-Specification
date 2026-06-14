import '../../../shared.dart';

class OrganizerSubmissionDetailsDialog {
  const OrganizerSubmissionDetailsDialog._();

  static Future<void> show(
    BuildContext context, {
    required ProjectSubmission submission,
    required ScoreProvider scores,
    required List<Team> teams,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(submission.projectName),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: [
              StatusPill(
                label: AppLabels.submissionStatus(submission.status),
                icon: Icons.task_alt_outlined,
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              DetailTile(
                title: AppStrings.teamTitle,
                value: teamName(submission.teamId, teams),
              ),
              DetailTile(
                title: AppStrings.repositoryButton,
                value: submission.githubUrl,
              ),
              DetailTile(
                title: AppStrings.demoButton,
                value: submission.videoUrl,
              ),
              DetailTile(
                title: AppStrings.eventFieldDescription,
                value: submission.description,
              ),
              DetailTile(
                title: AppStrings.averageScoreTitle,
                value: scores.averageFor(submission.id).toStringAsFixed(1),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.doneButton),
          ),
        ],
      ),
    );
  }

  static String teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return AppStrings.unknownTeamLabel;
  }
}
