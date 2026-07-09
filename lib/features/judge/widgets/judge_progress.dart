import '../../../shared.dart';

class JudgeProgress extends StatelessWidget {
  const JudgeProgress({
    super.key,
    required this.total,
    required this.scored,
    required this.unscored,
  });

  final int total;
  final int scored;
  final int unscored;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : scored / total;
    final seal = context.sealTheme;
    return Semantics(
      label: L10nService.strings.scoringProgressSemantic(scored, unscored),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: seal.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: seal.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10nService.strings.scoringProgressTitle,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(999),
                    color: unscored == 0
                        ? context.sealSecondary
                        : context.sealPrimary,
                    backgroundColor: seal.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusPill(
              label: '$scored/$total',
              color: unscored == 0
                  ? context.sealSecondary
                  : context.sealTertiary,
              icon: Icons.fact_check_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
