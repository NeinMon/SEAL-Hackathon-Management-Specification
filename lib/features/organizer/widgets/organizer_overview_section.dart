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
    this.focusEvent,
    this.teamCount,
    this.submissionCount,
  });

  final int activeEvents;
  final int unscored;
  final EventProvider events;
  final TeamProvider teams;
  final SubmissionProvider submissions;
  final ScoreProvider scores;
  final HackathonEvent? focusEvent;
  final int? teamCount;
  final int? submissionCount;

  @override
  Widget build(BuildContext context) {
    final teamsTotal = teamCount ?? teams.teams.length;
    final submissionsTotal = submissionCount ?? submissions.submissions.length;
    final scored = submissionsTotal - unscored;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (focusEvent != null) ...[
          StatusBanner(
            message: L10nService.strings.organizerFocusEventSubtitle(focusEvent!.title),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.go(AppRoutes.organizer),
              icon: Icon(Icons.filter_alt_off_outlined),
              label: Text(context.l10n.organizerShowAllEventsButton),
            ),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: L10nService.strings.eventsTitle,
                value: focusEvent == null ? '${events.events.length}' : '1',
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall + 2),
            Expanded(
              child: MetricCard(
                label: L10nService.strings.statusActive,
                value: '$activeEvents',
                accent: context.sealSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: L10nService.strings.teamTitle,
                value: '$teamsTotal',
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall + 2),
            Expanded(
              child: MetricCard(
                label: L10nService.strings.unscoredMetricLabel,
                value: '$unscored',
                accent: unscored == 0
                    ? context.sealSecondary
                    : context.sealTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        DashboardBars(
          teams: teamsTotal,
          submissions: submissionsTotal,
          scored: scored,
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
