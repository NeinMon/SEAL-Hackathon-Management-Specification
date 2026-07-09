import '../../../shared.dart';
import 'team_actions.dart';
import 'team_dialogs.dart';
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
    final eventTitle = event?.title ?? L10nService.strings.eventNotLoadedYet;
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
      label: context.l10n.teamSemanticLabelFor(
        team.name,
        team.members.length,
        leaderName,
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.sectionGap),
        color: highlighted ? context.sealPrimary.withValues(alpha: 0.08) : null,
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
                          style: TextStyle(
                            color: context.sealTheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          L10nService.strings.leaderPrefix(leaderName),
                          style: TextStyle(
                            color: context.sealTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLeader)
                    StatusPill(
                      label: L10nService.strings.leaderBadge,
                      color: context.sealSecondary,
                      icon: Icons.verified_outlined,
                    )
                  else if (teamIsFull)
                    StatusPill(
                      label: L10nService.strings.teamFullBadge,
                      color: context.sealTertiary,
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
                    label: context.l10n.memberCountWithLimitLabel(
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
                onSubmit: () => context.go(
                  RouteQuery.submitForTeam(team.id, eventId: team.eventId),
                ),
                onLeave: user == null || registrationClosed
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
    return L10nService.strings.unknownLabel;
  }

  Future<void> _showEditTeamDialog(BuildContext context, Team team) async {
    final newName = await TeamDialogs.editTeamName(context, team);
    if (newName == null || newName.isEmpty || !context.mounted) return;
    await context.read<TeamProvider>().updateTeamName(team.id, newName);
  }

  Future<void> _confirmLeaveTeam(
    BuildContext context,
    Team team,
    AppUser user,
  ) async {
    final shouldLeave = await TeamDialogs.confirmLeave(context, team);
    if (!shouldLeave || !context.mounted) return;
    await context.read<TeamProvider>().leaveTeam(team.id, user);
  }
}
