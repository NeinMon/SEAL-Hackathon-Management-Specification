import '../../../shared.dart';

class DashboardBarRow extends StatelessWidget {
  const DashboardBarRow({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.color = SealPalette.primary,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: value / maxValue,
                minHeight: 12,
                backgroundColor: SealPalette.surfaceContainerLow,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingSmall + 2),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardBars extends StatelessWidget {
  const DashboardBars({
    super.key,
    required this.teams,
    required this.submissions,
    required this.scored,
    required this.unscored,
  });

  final int teams;
  final int submissions;
  final int scored;
  final int unscored;

  @override
  Widget build(BuildContext context) {
    final maxValue = [
      teams,
      submissions,
      scored,
      unscored,
      1,
    ].reduce((value, element) => value > element ? value : element);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.dashboardChartTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            DashboardBarRow(
              label: AppStrings.teamTitle,
              value: teams,
              maxValue: maxValue,
            ),
            DashboardBarRow(
              label: AppStrings.submissionsMetricLabel,
              value: submissions,
              maxValue: maxValue,
            ),
            DashboardBarRow(
              label: AppStrings.scoredBarLabel,
              value: scored,
              maxValue: maxValue,
              color: SealPalette.secondary,
            ),
            DashboardBarRow(
              label: AppStrings.unscoredBarLabel,
              value: unscored,
              maxValue: maxValue,
              color: SealPalette.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
