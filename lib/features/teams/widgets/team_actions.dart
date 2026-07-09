import '../../../shared.dart';

class TeamActions extends StatelessWidget {
  const TeamActions({
    super.key,
    required this.isLeader,
    required this.isMember,
    required this.teamIsFull,
    required this.registrationClosed,
    required this.alreadyOnEventTeam,
    required this.user,
    required this.onSubmit,
    required this.onLeave,
    required this.onEdit,
    required this.onInvite,
  });

  final bool isLeader;
  final bool isMember;
  final bool teamIsFull;
  final bool registrationClosed;
  final bool alreadyOnEventTeam;
  final AppUser? user;
  final VoidCallback onSubmit;
  final VoidCallback? onLeave;
  final VoidCallback onEdit;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();
    if (isLeader) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: teamIsFull || registrationClosed ? null : onInvite,
            icon: Icon(Icons.person_add_alt_outlined),
            label: Text(context.l10n.inviteButton),
          ),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined),
            label: Text(context.l10n.editButton),
          ),
          TextButton.icon(
            onPressed: onSubmit,
            icon: Icon(Icons.upload_file_outlined),
            label: Text(context.l10n.submitNavLabel),
          ),
        ],
      );
    }
    if (isMember) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: onSubmit,
            icon: Icon(Icons.upload_file_outlined),
            label: Text(context.l10n.submitProjectButton),
          ),
          OutlinedButton.icon(
            onPressed: onLeave,
            icon: Icon(Icons.exit_to_app_outlined),
            label: Text(context.l10n.leaveTeamButton),
          ),
        ],
      );
    }
    if (teamIsFull) {
      return StatusPill(
        label: L10nService.strings.teamFullBadge,
        color: context.sealTertiary,
        icon: Icons.lock_outline,
      );
    }
    if (registrationClosed) {
      return StatusPill(
        label: L10nService.strings.registrationClosedPill,
        color: context.sealTheme.onSurfaceVariant,
        icon: Icons.lock_clock_outlined,
      );
    }
    if (alreadyOnEventTeam) {
      return StatusPill(
        label: L10nService.strings.oneTeamPerEventBadge,
        color: context.sealTertiary,
        icon: Icons.info_outline,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusPill(
          label: L10nService.strings.teamInviteOnlyBadge,
          color: context.sealTertiary,
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 8),
        Text(
          L10nService.strings.teamInviteOnlyHelper,
          style: TextStyle(color: context.sealTheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
