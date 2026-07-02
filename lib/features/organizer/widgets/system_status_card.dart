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
      label: AppStrings.systemStatusSemanticLabel,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.systemStatusTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                AppStrings.systemStatusSubtitle,
                style: TextStyle(color: SealPalette.onSurfaceVariant),
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(
                    label: AppStrings.operationsDataLabel,
                    icon: Icons.dns_outlined,
                  ),
                  StatusPill(
                    label: SupabaseConfig.isConfigured
                        ? AppStrings.databaseConnectedLabel
                        : AppStrings.databaseMissingLabel,
                    color: SupabaseConfig.isConfigured
                        ? SealPalette.secondary
                        : SealPalette.error,
                    icon: SupabaseConfig.isConfigured
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                  ),
                  StatusPill(
                    label: loading
                        ? AppStrings.syncingLabel
                        : AppStrings.stateReadyLabel,
                    color: loading ? SealPalette.tertiary : SealPalette.primary,
                    icon: loading
                        ? Icons.sync_outlined
                        : Icons.check_circle_outline,
                  ),
                  StatusPill(
                    label: auth.user == null
                        ? AppStrings.notLoggedInShortLabel
                        : AppRoles.label(auth.user!.role),
                    icon: Icons.verified_user_outlined,
                  ),
                  StatusPill(
                    label: errors.isEmpty
                        ? AppStrings.noApiErrorsLabel
                        : AppStrings.apiErrorCountLabel(errors.length),
                    color: errors.isEmpty
                        ? SealPalette.secondary
                        : SealPalette.error,
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
                      label: AppStrings.eventsTitle,
                      value: '${events.events.length}',
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall + 2),
                  Expanded(
                    child: MetricCard(
                      label: AppStrings.teamTitle,
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
                      label: AppStrings.submissionsMetricLabel,
                      value: '${submissions.submissions.length}',
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall + 2),
                  Expanded(
                    child: MetricCard(
                      label: AppStrings.scoresMetricLabel,
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
