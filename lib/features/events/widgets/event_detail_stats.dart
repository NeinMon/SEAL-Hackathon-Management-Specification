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
              L10nService.strings.eventDetailStatsTitle,
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
                    label: L10nService.strings.eventTeamsMetric,
                    value: '$teamCount',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    icon: Icons.upload_file_outlined,
                    label: L10nService.strings.eventSubmissionsMetric,
                    value: '$submissionCount',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    icon: Icons.pending_actions_outlined,
                    label: L10nService.strings.eventUnscoredMetric,
                    value: '$unscoredCount',
                    accent: unscoredCount == 0
                        ? context.sealSecondary
                        : context.sealTertiary,
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
    final color = accent ?? context.sealPrimary;
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
