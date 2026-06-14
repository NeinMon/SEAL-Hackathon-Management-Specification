import '../../../shared.dart';
import 'judge_score_metric.dart';

class JudgeScoreSummaryCard extends StatelessWidget {
  const JudgeScoreSummaryCard({
    super.key,
    required this.currentAverage,
    required this.feedbackReady,
    required this.existingScore,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onSubmit,
  });

  final double currentAverage;
  final bool feedbackReady;
  final ProjectScore? existingScore;
  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: JudgeScoreMetric(
                  label: AppStrings.currentScoreLabel,
                  value: currentAverage.toStringAsFixed(1),
                  accent: SealPalette.tertiary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: JudgeScoreMetric(
                  label: AppStrings.feedbackLabel,
                  value: feedbackReady
                      ? AppStrings.feedbackReady
                      : AppStrings.feedbackMissing,
                  accent: feedbackReady
                      ? SealPalette.secondary
                      : SealPalette.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: !canSubmit || isSubmitting ? null : onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(
              existingScore == null
                  ? AppStrings.submitScoreButton
                  : AppStrings.updateScoreButton,
            ),
          ),
        ],
      ),
    );
  }
}
