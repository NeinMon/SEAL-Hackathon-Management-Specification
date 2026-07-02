import '../../../shared.dart';
import 'team_actions.dart';
import 'team_invite_flow.dart';
import 'team_member_avatar.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.currentUser,
    required this.event,
    required this.allTeams,
    this.highlighted = false,
  });

  final Team team;
  final AppUser? currentUser;
  final HackathonEvent? event;
  final List<Team> allTeams;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final isMember =
        user != null && team.members.any((member) => member.id == user.id);
    final isLeader = user != null && team.leaderId == user.id;
    final leaderName = _leaderName(team);
    final eventTitle = event?.title ?? AppStrings.eventNotLoadedYet;
    final memberLimit = event?.maxTeamSize ?? 0;
    final teamIsFull = memberLimit > 0 && team.members.length >= memberLimit;
    final registrationClosed = event != null && !event!.registrationOpen();
    final alreadyOnEventTeam = user != null && event != null
        ? TeamMembership.hasTeamOnEvent(
            teams: allTeams,
            userId: user.id,
            eventId: event!.id,
            excludeTeamId: team.id,
          )
        : false;
    return Semantics(
      label:
          'Team ${team.name}, ${AppStrings.memberCountLabel(team.members.length)}, ${AppStrings.leaderPrefix(leaderName)}',
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.sectionGap),
        color: highlighted ? SealPalette.primary.withValues(alpha: 0.08) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MemberAvatarStack(members: team.members),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eventTitle,
                          style: const TextStyle(
                            color: SealPalette.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.leaderPrefix(leaderName),
                          style: const TextStyle(
                            color: SealPalette.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLeader)
                    const StatusPill(
                      label: AppStrings.leaderBadge,
                      color: SealPalette.secondary,
                      icon: Icons.verified_outlined,
                    )
                  else if (teamIsFull)
                    const StatusPill(
                      label: AppStrings.teamFullBadge,
                      color: SealPalette.tertiary,
                      icon: Icons.lock_outline,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  StatusPill(
                    label: AppStrings.memberCountWithLimit(
                      team.members.length,
                      memberLimit,
                    ),
                    icon: Icons.groups_outlined,
                  ),
                  for (final member in team.members.take(3))
                    StatusPill(label: member.fullName),
                ],
              ),
              const SizedBox(height: 12),
              TeamActions(
                isLeader: isLeader,
                isMember: isMember,
                teamIsFull: teamIsFull,
                registrationClosed: registrationClosed,
                alreadyOnEventTeam: alreadyOnEventTeam,
                user: user,
                onSubmit: () => context.go(AppRoutes.submit),
                onJoin: user == null || registrationClosed || alreadyOnEventTeam
                    ? null
                    : () => context.read<TeamProvider>().joinTeam(
                        team.id,
                        user,
                        event: event,
                      ),
                onLeave: user == null
                    ? null
                    : () => _confirmLeaveTeam(context, team, user),
                onEdit: () => _showEditTeamDialog(context, team),
                onInvite: registrationClosed
                    ? () {}
                    : () => TeamInviteFlow.show(
                        context,
                        team: team,
                        event: event,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _leaderName(Team team) {
    for (final member in team.members) {
      if (member.id == team.leaderId) return member.fullName;
    }
    return AppStrings.unknownLabel;
  }

  Future<void> _showEditTeamDialog(BuildContext context, Team team) async {
    final controller = TextEditingController(text: team.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.updateTeamDialogTitle),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: AppStrings.teamNameLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text(AppStrings.saveButton),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || !context.mounted) return;
    await context.read<TeamProvider>().updateTeamName(team.id, newName);
  }

  Future<void> _confirmLeaveTeam(
    BuildContext context,
    Team team,
    AppUser user,
  ) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.leaveTeamDialogTitle),
        content: Text(AppStrings.leaveTeamDialogBody(team.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.leaveTeamButton),
          ),
        ],
      ),
    );
    if (shouldLeave != true || !context.mounted) return;
    await context.read<TeamProvider>().leaveTeam(team.id, user);
  }
}
