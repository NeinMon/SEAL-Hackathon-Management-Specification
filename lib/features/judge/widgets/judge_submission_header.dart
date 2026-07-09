import '../../../shared.dart';

class JudgeSubmissionHeader extends StatelessWidget {
  const JudgeSubmissionHeader({
    super.key,
    required this.submission,
    required this.teamName,
    required this.eventTitle,
    required this.hasExistingScore,
    required this.scoreCount,
    required this.onOpenRepository,
    required this.onOpenDemo,
  });

  final ProjectSubmission submission;
  final String teamName;
  final String? eventTitle;
  final bool hasExistingScore;
  final int scoreCount;
  final VoidCallback onOpenRepository;
  final VoidCallback onOpenDemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: context.sealPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.sealTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: hasExistingScore
                    ? L10nService.strings.filterScored
                    : L10nService.strings.needsScoringBadge,
                color: hasExistingScore
                    ? context.sealSecondary
                    : context.sealTertiary,
                icon: hasExistingScore
                    ? Icons.verified_outlined
                    : Icons.pending_actions_outlined,
              ),
              StatusPill(
                label: L10nService.strings.scoreCountLabel(scoreCount),
                icon: Icons.leaderboard_outlined,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            submission.projectName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: context.onSurfaceColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$teamName - ${eventTitle ?? L10nService.strings.eventNotLoadedYet}',
            style: TextStyle(
              color: context.sealTheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            submission.description,
            style: TextStyle(
              color: context.sealTheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onOpenRepository,
                icon: Icon(Icons.code_outlined),
                label: Text(context.l10n.repositoryButton),
              ),
              OutlinedButton.icon(
                onPressed: onOpenDemo,
                icon: Icon(Icons.play_circle_outline),
                label: Text(context.l10n.demoButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
