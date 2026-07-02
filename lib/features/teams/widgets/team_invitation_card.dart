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
                const Icon(Icons.mail_outline, color: SealPalette.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team?.name ?? AppStrings.unknownTeamLabel,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event?.title ?? AppStrings.eventNotLoadedYet,
                        style: const TextStyle(
                          color: SealPalette.onSurfaceVariant,
                        ),
                      ),
                      if (inviter != null) ...[
                        const SizedBox(height: 4),
                        Text(AppStrings.invitedByLabel(inviter.fullName)),
                      ],
                    ],
                  ),
                ),
                const StatusPill(
                  label: AppStrings.invitationStatusPending,
                  icon: Icons.schedule_outlined,
                  color: SealPalette.tertiary,
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
                  icon: const Icon(Icons.check),
                  label: const Text(AppStrings.acceptInvitationButton),
                ),
                OutlinedButton.icon(
                  onPressed: () => context
                      .read<TeamProvider>()
                      .declineInvitation(invitation.id, currentUser),
                  icon: const Icon(Icons.close),
                  label: const Text(AppStrings.declineInvitationButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
