import '../../../shared.dart';
import 'team_actions.dart';
import 'team_dialogs.dart';
import 'team_member_avatar.dart';

class TeamCard extends StatefulWidget {
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
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  final _inviteEmail = TextEditingController();
  final _inviteFormKey = GlobalKey<FormState>();
  bool _showInviteForm = false;

  @override
  void dispose() {
    _inviteEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser;
    final team = widget.team;
    final event = widget.event;
    final isMember =
        user != null && team.members.any((member) => member.id == user.id);
    final isLeader = user != null && team.leaderId == user.id;
    final leaderName = _leaderName(team);
    final eventTitle = event?.title ?? L10nService.strings.eventNotLoadedYet;
    final memberLimit = event?.maxTeamSize ?? 0;
    final teamIsFull = memberLimit > 0 && team.members.length >= memberLimit;
    final registrationClosed = event != null && !event.registrationOpen();
    final alreadyOnEventTeam = user != null && event != null
        ? TeamMembership.hasTeamOnEvent(
            teams: widget.allTeams,
            userId: user.id,
            eventId: event.id,
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
        color: widget.highlighted
            ? context.sealPrimary.withValues(alpha: 0.08)
            : null,
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
                onLeave: user == null || registrationClosed
                    ? null
                    : () => _confirmLeaveTeam(context, team, user),
                onEdit: () => _showEditTeamDialog(context, team),
                onInvite: registrationClosed
                    ? () {}
                    : () => setState(() => _showInviteForm = !_showInviteForm),
              ),
              if (_showInviteForm && isLeader) ...[
                const SizedBox(height: 12),
                _InlineInviteForm(
                  formKey: _inviteFormKey,
                  controller: _inviteEmail,
                  team: team,
                  event: event,
                  isLoading: context.watch<TeamProvider>().isLoading,
                  onCancel: () {
                    _inviteEmail.clear();
                    setState(() => _showInviteForm = false);
                  },
                  onSubmit: () => _submitInvite(context, team, event),
                ),
              ],
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

  Future<void> _submitInvite(
    BuildContext context,
    Team team,
    HackathonEvent? event,
  ) async {
    if (!(_inviteFormKey.currentState?.validate() ?? false)) return;
    final messenger = ScaffoldMessenger.of(context);
    final teamProvider = context.read<TeamProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final email = _inviteEmail.text.trim();
    messenger.showSnackBar(
      SnackBar(content: Text(L10nService.strings.invitationSendingStatus)),
    );
    await teamProvider.inviteMember(team.id, email, event: event);
    if (!mounted || !context.mounted) return;
    if (teamProvider.error != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(teamProvider.error!)));
      return;
    }
    final invited = await const UserDirectoryService().findByEmail(email);
    if (!mounted || !context.mounted) return;
    if (invited != null && event != null) {
      await notificationProvider.push(
        L10nService.strings.teamInvitationTitle,
        NotificationLink.encodeEvent(
          eventId: event.id,
          content: L10nService.strings.teamInvitationBody(team.name),
        ),
        'invitation',
        userId: invited.id,
        actionLabel: L10nService.strings.notificationActionGoTeams,
        deepRoute: RouteQuery.teamsForEvent(event.id),
      );
    }
    if (!mounted || !context.mounted) return;
    _inviteEmail.clear();
    setState(() => _showInviteForm = false);
    if (!context.mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(L10nService.strings.invitationSentSuccess)),
      );
  }
}

class _InlineInviteForm extends StatelessWidget {
  const _InlineInviteForm({
    required this.formKey,
    required this.controller,
    required this.team,
    required this.event,
    required this.isLoading,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Team team;
  final HackathonEvent? event;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.sealPrimary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.sealPrimary.withValues(alpha: 0.16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                L10nService.strings.inviteTeamPrefix(team.name),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              if (event != null) ...[
                const SizedBox(height: 4),
                Text(
                  event!.title,
                  style: TextStyle(color: context.sealTheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 10),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: AppValidators.inviteEmail,
                onFieldSubmitted: (_) => isLoading ? null : onSubmit(),
                decoration: InputDecoration(
                  labelText: L10nService.strings.memberEmailLabel,
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : onCancel,
                    child: Text(L10nService.strings.cancelButton),
                  ),
                  FilledButton.icon(
                    onPressed: isLoading ? null : onSubmit,
                    icon: isLoading
                        ? const SizedBox.square(
                            dimension: AppSizes.iconSmall,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.send_outlined),
                    label: Text(L10nService.strings.sendInvitationButton),
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
