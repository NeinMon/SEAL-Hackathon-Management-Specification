import '../../../shared.dart';

class TeamInvitationCard extends StatelessWidget {
  const TeamInvitationCard({
    super.key,
    required this.invitation,
    required this.currentUser,
    required this.event,
  });

  final TeamInvitation invitation;
  final AppUser currentUser;
  final HackathonEvent? event;

  @override
  Widget build(BuildContext context) {
    final team = invitation.team;
    final inviter = invitation.inviter;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mail_outline, color: context.sealPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team?.name ?? L10nService.strings.unknownTeamLabel,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event?.title ?? L10nService.strings.eventNotLoadedYet,
                        style: TextStyle(
                          color: context.sealTheme.onSurfaceVariant,
                        ),
                      ),
                      if (inviter != null) ...[
                        const SizedBox(height: 4),
                        Text(context.l10n.invitedByLabel(inviter.fullName)),
                      ],
                    ],
                  ),
                ),
                StatusPill(
                  label: L10nService.strings.invitationStatusPending,
                  icon: Icons.schedule_outlined,
                  color: context.sealTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: event == null
                      ? null
                      : () => context.read<TeamProvider>().acceptInvitation(
                          invitation,
                          currentUser,
                          event: event,
                        ),
                  icon: Icon(Icons.check),
                  label: Text(context.l10n.acceptInvitationButton),
                ),
                OutlinedButton.icon(
                  onPressed: () => context
                      .read<TeamProvider>()
                      .declineInvitation(invitation.id, currentUser),
                  icon: Icon(Icons.close),
                  label: Text(context.l10n.declineInvitationButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
