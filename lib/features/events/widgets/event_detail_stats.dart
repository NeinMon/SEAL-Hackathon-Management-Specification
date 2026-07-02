import '../../../shared.dart';

class EventDetailStats extends StatelessWidget {
  const EventDetailStats({
    super.key,
    required this.teamCount,
    required this.submissionCount,
    required this.unscoredCount,
  });

  final int teamCount;
  final int submissionCount;
  final int unscoredCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.eventDetailStatsTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: context.onSurfaceColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.groups_outlined,
                    label: AppStrings.eventTeamsMetric,
                    value: '$teamCount',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    icon: Icons.upload_file_outlined,
                    label: AppStrings.eventSubmissionsMetric,
                    value: '$submissionCount',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    icon: Icons.pending_actions_outlined,
                    label: AppStrings.eventUnscoredMetric,
                    value: '$unscoredCount',
                    accent: unscoredCount == 0
                        ? SealPalette.secondary
                        : SealPalette.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? SealPalette.primary;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.sealTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.sealTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: context.sealTheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
