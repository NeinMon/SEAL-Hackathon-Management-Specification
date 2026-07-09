import '../../../shared.dart';

class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({
    super.key,
    required this.events,
    required this.teams,
    required this.submissions,
    required this.scores,
  });

  final EventProvider events;
  final TeamProvider teams;
  final SubmissionProvider submissions;
  final ScoreProvider scores;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final loading =
        events.isLoading ||
        teams.isLoading ||
        submissions.isLoading ||
        scores.isLoading;
    final errors = [
      events.error,
      teams.error,
      submissions.error,
      scores.error,
    ].whereType<String>().toList();
    return Semantics(
      label: L10nService.strings.systemStatusSemanticLabel,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nService.strings.systemStatusTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                L10nService.strings.systemStatusSubtitle,
                style: TextStyle(color: context.sealTheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(
                    label: L10nService.strings.operationsDataLabel,
                    icon: Icons.dns_outlined,
                  ),
                  StatusPill(
                    label: SupabaseConfig.isConfigured
                        ? L10nService.strings.databaseConnectedLabel
                        : L10nService.strings.databaseMissingLabel,
                    color: SupabaseConfig.isConfigured
                        ? context.sealSecondary
                        : context.sealError,
                    icon: SupabaseConfig.isConfigured
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                  ),
                  StatusPill(
                    label: loading
                        ? L10nService.strings.syncingLabel
                        : L10nService.strings.stateReadyLabel,
                    color: loading
                        ? context.sealTertiary
                        : context.sealPrimary,
                    icon: loading
                        ? Icons.sync_outlined
                        : Icons.check_circle_outline,
                  ),
                  StatusPill(
                    label: auth.user == null
                        ? L10nService.strings.notLoggedInShortLabel
                        : AppRoles.label(auth.user!.role),
                    icon: Icons.verified_user_outlined,
                  ),
                  StatusPill(
                    label: errors.isEmpty
                        ? L10nService.strings.noApiErrorsLabel
                        : L10nService.strings.apiErrorCountLabel(errors.length),
                    color: errors.isEmpty
                        ? context.sealSecondary
                        : context.sealError,
                    icon: errors.isEmpty
                        ? Icons.verified_outlined
                        : Icons.error_outline,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: L10nService.strings.eventsTitle,
                      value: '${events.events.length}',
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall + 2),
                  Expanded(
                    child: MetricCard(
                      label: L10nService.strings.teamTitle,
                      value: '${teams.teams.length}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: L10nService.strings.submissionsMetricLabel,
                      value: '${submissions.submissions.length}',
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall + 2),
                  Expanded(
                    child: MetricCard(
                      label: L10nService.strings.scoresMetricLabel,
                      value: '${scores.scores.length}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
