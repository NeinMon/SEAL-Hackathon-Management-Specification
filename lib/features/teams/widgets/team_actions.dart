import '../../../shared.dart';

class TeamActions extends StatelessWidget {
  const TeamActions({
    super.key,
    required this.isLeader,
    required this.isMember,
    required this.teamIsFull,
    required this.user,
    required this.onSubmit,
    required this.onJoin,
    required this.onLeave,
    required this.onEdit,
    required this.onInvite,
  });

  final bool isLeader;
  final bool isMember;
  final bool teamIsFull;
  final AppUser? user;
  final VoidCallback onSubmit;
  final VoidCallback? onJoin;
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
            onPressed: teamIsFull ? null : onInvite,
            icon: const Icon(Icons.person_add_alt_outlined),
            label: const Text(AppStrings.inviteButton),
          ),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text(AppStrings.editButton),
          ),
          TextButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text(AppStrings.submitNavLabel),
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
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text(AppStrings.submitProjectButton),
          ),
          OutlinedButton.icon(
            onPressed: onLeave,
            icon: const Icon(Icons.exit_to_app_outlined),
            label: const Text(AppStrings.leaveTeamButton),
          ),
        ],
      );
    }
    if (teamIsFull) {
      return const StatusPill(
        label: AppStrings.teamFullBadge,
        color: SealPalette.tertiary,
        icon: Icons.lock_outline,
      );
    }
    return FilledButton.icon(
      onPressed: onJoin,
      icon: const Icon(Icons.group_add_outlined),
      label: const Text(AppStrings.joinTeamButton),
    );
  }
}
