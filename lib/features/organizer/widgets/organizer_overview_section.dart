import '../../../shared.dart';
import 'dashboard_bars.dart';
import 'system_status_card.dart';

class OrganizerOverviewSection extends StatelessWidget {
  const OrganizerOverviewSection({
    super.key,
    required this.activeEvents,
    required this.unscored,
    required this.events,
    required this.teams,
    required this.submissions,
    required this.scores,
  });

  final int activeEvents;
  final int unscored;
  final EventProvider events;
  final TeamProvider teams;
  final SubmissionProvider submissions;
  final ScoreProvider scores;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: AppStrings.eventsTitle,
                value: '${events.events.length}',
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall + 2),
            Expanded(
              child: MetricCard(
                label: AppStrings.statusActive,
                value: '$activeEvents',
                accent: SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: AppStrings.teamTitle,
                value: '${teams.teams.length}',
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall + 2),
            Expanded(
              child: MetricCard(
                label: AppStrings.unscoredMetricLabel,
                value: '$unscored',
                accent: unscored == 0
                    ? SealPalette.secondary
                    : SealPalette.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        DashboardBars(
          teams: teams.teams.length,
          submissions: submissions.submissions.length,
          scored: submissions.submissions.length - unscored,
          unscored: unscored,
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        SystemStatusCard(
          events: events,
          teams: teams,
          submissions: submissions,
          scores: scores,
        ),
      ],
    );
  }
}
