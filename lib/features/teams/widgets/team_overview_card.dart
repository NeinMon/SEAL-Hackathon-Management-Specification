import '../../../shared.dart';

class TeamOverviewCard extends StatelessWidget {
  const TeamOverviewCard({
    super.key,
    required this.scopedTeamCount,
    required this.pendingInvitations,
    required this.hasMyTeam,
    this.eventTitle,
  });

  final int scopedTeamCount;
  final int pendingInvitations;
  final bool hasMyTeam;
  final String? eventTitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.sealTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventTitle == null
                        ? L10nService.strings.teamOverviewTitle
                        : L10nService.strings.teamOverviewForEvent(eventTitle!),
                    style: TextStyle(
                      color: theme.onSurfaceVariant,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                StatusPill(
                  label: hasMyTeam
                      ? L10nService.strings.myTeamReadyBadge
                      : L10nService.strings.myTeamPendingBadge,
                  color: hasMyTeam ? context.sealSecondary : context.sealTertiary,
                  icon: hasMyTeam
                      ? Icons.verified_outlined
                      : Icons.hourglass_empty_outlined,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            Text(
              scopedTeamCount == 0
                  ? L10nService.strings.noTeamsYet
                  : L10nService.strings.scopedTeamsAvailable(scopedTeamCount),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            if (pendingInvitations > 0) ...[
              const SizedBox(height: 8),
              Text(
                L10nService.strings.pendingInvitationsCount(pendingInvitations),
                style: TextStyle(color: theme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
