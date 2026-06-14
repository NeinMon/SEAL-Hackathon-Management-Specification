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
    return Semantics(
      label: AppStrings.scoringProgressSemantic(scored, unscored),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SealPalette.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SealPalette.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.scoringProgressTitle,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(999),
                    color: unscored == 0
                        ? SealPalette.secondary
                        : SealPalette.primary,
                    backgroundColor: SealPalette.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusPill(
              label: '$scored/$total',
              color: unscored == 0
                  ? SealPalette.secondary
                  : SealPalette.tertiary,
              icon: Icons.fact_check_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
