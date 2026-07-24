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
    this.compact = false,
  });

  final ProjectSubmission submission;
  final String teamName;
  final String? eventTitle;
  final bool hasExistingScore;
  final int scoreCount;
  final VoidCallback onOpenRepository;
  final VoidCallback onOpenDemo;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final linkButtonStyle = TextButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
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
        ],
        Text(
          '$teamName - ${eventTitle ?? L10nService.strings.eventNotLoadedYet}',
          style: TextStyle(
            color: context.sealTheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: compact ? 13 : 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          submission.description,
          maxLines: compact ? 2 : 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.sealTheme.onSurfaceVariant,
            height: 1.35,
            fontSize: compact ? 13 : 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            TextButton.icon(
              style: linkButtonStyle,
              onPressed: onOpenRepository,
              icon: const Icon(Icons.code_outlined, size: 18),
              label: Text(context.l10n.repositoryButton),
            ),
            TextButton.icon(
              style: linkButtonStyle,
              onPressed: onOpenDemo,
              icon: const Icon(Icons.play_circle_outline, size: 18),
              label: Text(context.l10n.demoButton),
            ),
          ],
        ),
      ],
    );

    if (compact) return content;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: context.sealPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.sealTheme.outlineVariant),
      ),
      child: content,
    );
  }
}
