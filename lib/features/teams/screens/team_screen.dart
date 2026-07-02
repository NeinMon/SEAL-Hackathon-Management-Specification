import '../../../shared.dart';
import '../widgets/team_card.dart';
import '../widgets/team_create_form.dart';
import '../widgets/team_group_title.dart';
import '../widgets/team_invitation_card.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final _createFormKey = GlobalKey<FormState>();
  final name = TextEditingController();
  String? selectedEventId;
  bool showCreateTeam = false;

  @override
  void initState() {
    super.initState();
    name.addListener(_refreshCreateForm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyRouteQuery();
      context.read<EventProvider>().loadEvents();
      context.read<TeamProvider>().loadTeamWorkspace(
        context.read<AuthProvider>().user,
      );
    });
  }

  void _applyRouteQuery() {
    if (!mounted) return;
    final eventId = RouteQuery.eventIdFrom(context);
    if (eventId != null && eventId != selectedEventId) {
      setState(() => selectedEventId = eventId);
    }
  }

  @override
  void dispose() {
    name
      ..removeListener(_refreshCreateForm)
      ..dispose();
    super.dispose();
  }

  void _refreshCreateForm() {
    if (mounted) setState(() {});
  }

  Future<void> _createTeam(
    TeamProvider teams,
    HackathonEvent selectedEvent,
    AppUser user,
  ) async {
    if (!(_createFormKey.currentState?.validate() ?? false)) return;
    final teamName = name.text.trim();
    await teams.createTeam(teamName, selectedEvent, user);
    if (!mounted) return;
    if (teams.error == null) {
      setState(() {
        showCreateTeam = false;
        name.clear();
      });
      await context.read<NotificationProvider>().push(
        AppStrings.teamCreatedNotificationTitle,
        AppStrings.teamCreatedNotificationBody(teamName, selectedEvent.title),
        'invitation',
        userId: user.id,
      );
    }
  }

  void _cancelCreateTeam() {
    setState(() {
      showCreateTeam = false;
      name.clear();
      _createFormKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final user = auth.user;
    final selectedEvent = _selectedEvent(events.events);
    final loading = events.isLoading || teams.isLoading;
    final myTeams = user == null
        ? <Team>[]
        : teams.teams
              .where(
                (team) => team.members.any((member) => member.id == user.id),
              )
              .toList();
    final pendingInvitations = user == null
        ? <TeamInvitation>[]
        : teams.invitations
              .where(
                (invitation) =>
                    invitation.isPending && invitation.inviteeId == user.id,
              )
              .toList();
    final routeEventId = RouteQuery.eventIdFrom(context);
    final filterEventId = selectedEvent?.id ?? routeEventId;
    final scopedTeams = filterEventId == null
        ? teams.teams
        : teams.teams.where((team) => team.eventId == filterEventId).toList();
    final myTeamForSelectedEvent = user == null || selectedEvent == null
        ? null
        : TeamMembership.teamForUserOnEvent(
            teams: teams.teams,
            userId: user.id,
            eventId: selectedEvent.id,
          );
    final otherTeams = user == null
        ? scopedTeams
        : scopedTeams
              .where(
                (team) => !team.members.any((member) => member.id == user.id),
              )
              .toList();
    final visibleMyTeams = filterEventId == null
        ? myTeams
        : myTeams.where((team) => team.eventId == filterEventId).toList();
    final canCreateTeamRole =
        user != null && AppRoles.participantCreators.contains(user.role);
    final canCreateTeam =
        canCreateTeamRole &&
        selectedEvent != null &&
        selectedEvent.registrationOpen() &&
        myTeamForSelectedEvent == null &&
        !loading;
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: AppStrings.teamTitle,
          subtitle: AppStrings.teamSubtitle,
          icon: Icons.groups_outlined,
          trailing: IconButton.filledTonal(
            tooltip: AppStrings.reloadTeamsTooltip,
            onPressed: loading
                ? null
                : () => Future.wait([
                    context.read<EventProvider>().loadEvents(),
                    context.read<TeamProvider>().loadTeamWorkspace(user),
                  ]),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (events.error != null)
          StatusBanner(message: events.error!, isError: true),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        AppStrings.teamOverviewTitle,
                        style: TextStyle(
                          color: SealPalette.onSurfaceVariant,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: SealPalette.secondary.withValues(alpha: 0.12),
                        border: Border.all(
                          color: SealPalette.secondary.withValues(alpha: 0.45),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        AppStrings.statusActive,
                        style: TextStyle(
                          color: SealPalette.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingCompact),
                Text(
                  teams.teams.isEmpty
                      ? AppStrings.noTeamsYet
                      : AppStrings.teamsAvailable,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: teams.teams.isEmpty ? 0.25 : 0.85,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                  color: SealPalette.secondary,
                  backgroundColor: SealPalette.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: AppStrings.teamTitle,
                value: '${teams.teams.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: AppStrings.checkInLabel,
                value: teams.teams.isEmpty
                    ? AppStrings.checkInPending
                    : AppStrings.checkInConfirmed,
                accent: teams.teams.isEmpty
                    ? SealPalette.tertiary
                    : SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        if (myTeamForSelectedEvent != null) ...[
          FilledButton.icon(
            onPressed: loading
                ? null
                : () => context.go(
                    RouteQuery.submitForTeam(myTeamForSelectedEvent.id),
                  ),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text(AppStrings.submitProjectButton),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
        ],
        if (showCreateTeam ||
            (teams.teams.isEmpty && myTeamForSelectedEvent == null))
          TeamCreateForm(
            formKey: _createFormKey,
            nameController: name,
            events: events.events,
            selectedEvent: selectedEvent,
            loading: loading,
            canCreateTeam: canCreateTeam,
            showCancel: teams.teams.isNotEmpty,
            user: user,
            onEventChanged: (value) => setState(() => selectedEventId = value),
            onCancel: _cancelCreateTeam,
            onSubmit: selectedEvent == null || user == null
                ? () {}
                : () => _createTeam(teams, selectedEvent, user),
          )
        else if (canCreateTeamRole && myTeamForSelectedEvent == null) ...[
          FilledButton.icon(
            onPressed: loading || !canCreateTeam
                ? null
                : () => setState(() => showCreateTeam = true),
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.createTeamButton),
          ),
          if (!loading &&
              selectedEvent != null &&
              !selectedEvent.registrationOpen()) ...[
            const SizedBox(height: 8),
            Text(
              selectedEvent.registrationBlockReason() ??
                  AppStrings.errorRegistrationDeadlinePassed,
              style: TextStyle(color: context.sealTheme.onSurfaceVariant),
            ),
          ],
        ],
        const SizedBox(height: AppSizes.paddingMedium),
        if (teams.error != null && teams.teams.isEmpty)
          ErrorState(
            message: teams.error!,
            onRetry: () => context.read<TeamProvider>().loadTeamWorkspace(user),
          )
        else if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (teams.message != null) StatusBanner(message: teams.message!),
        if (pendingInvitations.isNotEmpty) ...[
          const TeamGroupTitle(title: AppStrings.pendingInvitationsTitle),
          for (final invitation in pendingInvitations)
            TeamInvitationCard(
              invitation: invitation,
              currentUser: user!,
              event: _eventFor(invitation.team?.eventId ?? '', events.events),
            ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        if (loading)
          const LoadingCardList(itemCount: 2)
        else if (teams.teams.isEmpty)
          const EmptyState(message: AppStrings.emptyTeamsMessage)
        else ...[
          if (visibleMyTeams.isNotEmpty) ...[
            const TeamGroupTitle(title: AppStrings.myTeamsGroup),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleMyTeams.length,
              itemBuilder: (context, index) {
                final team = visibleMyTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: _eventFor(team.eventId, events.events),
                  allTeams: teams.teams,
                  highlighted: true,
                );
              },
            ),
          ],
          if (otherTeams.isNotEmpty) ...[
            const TeamGroupTitle(title: AppStrings.otherTeamsGroup),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: otherTeams.length,
              itemBuilder: (context, index) {
                final team = otherTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: _eventFor(team.eventId, events.events),
                  allTeams: teams.teams,
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  HackathonEvent? _selectedEvent(List<HackathonEvent> events) {
    if (events.isEmpty) return null;
    for (final event in events) {
      if (event.id == selectedEventId) return event;
    }
    return events.first;
  }

  HackathonEvent? _eventFor(String eventId, List<HackathonEvent> events) {
    for (final event in events) {
      if (event.id == eventId) return event;
    }
    return null;
  }
}
