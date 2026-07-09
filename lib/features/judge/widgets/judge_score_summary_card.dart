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
    final seal = context.sealTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: seal.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: seal.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: JudgeScoreMetric(
                  label: L10nService.strings.currentScoreLabel,
                  value: currentAverage.toStringAsFixed(1),
                  accent: context.sealTertiary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: JudgeScoreMetric(
                  label: L10nService.strings.feedbackLabel,
                  value: feedbackReady
                      ? L10nService.strings.feedbackReady
                      : L10nService.strings.feedbackMissing,
                  accent: feedbackReady
                      ? context.sealSecondary
                      : context.sealError,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            L10nService.strings.weightedScoreHint,
            style: TextStyle(
              color: seal.onSurfaceVariant,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: !canSubmit || isSubmitting ? null : onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.check),
            label: Text(
              existingScore == null
                  ? L10nService.strings.submitScoreButton
                  : L10nService.strings.updateScoreButton,
            ),
          ),
        ],
      ),
    );
  }
}
