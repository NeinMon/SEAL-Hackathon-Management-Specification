import '../../../shared.dart';
import '../helpers/team_screen_view_data.dart';
import '../widgets/team_screen_body.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyRouteQuery());
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
      await context.read<NotificationProvider>().notifyTeamCreated(
        userId: user.id,
        teamName: teamName,
        eventTitle: selectedEvent.title,
        eventId: selectedEvent.id,
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

  HackathonEvent? _selectedEvent(List<HackathonEvent> events) {
    final active = context.read<ActiveEventProvider>().eventFor(
      events: events,
      routeEventId: RouteQuery.eventIdFrom(context),
      userId: context.read<AuthProvider>().user?.id,
      teams: context.read<TeamProvider>().teams,
    );
    if (active != null) return active;
    if (events.isEmpty) return null;
    for (final event in events) {
      if (event.id == selectedEventId) return event;
    }
    return events.first;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final selectedEvent = _selectedEvent(events.events);
    final viewData = TeamScreenViewData.compute(
      user: auth.user,
      events: events,
      teams: teams,
      selectedEvent: selectedEvent,
      routeEventId: RouteQuery.eventIdFrom(context),
    );

    return TeamScreenBody(
      viewData: viewData,
      events: events.events,
      teams: teams,
      eventsError: events.error,
      showCreateTeam: showCreateTeam,
      createFormKey: _createFormKey,
      nameController: name,
      onRefresh: () => Future.wait([
        context.read<EventProvider>().loadEvents(),
        context.read<TeamProvider>().loadTeamWorkspace(auth.user),
      ]),
      onEventChanged: (value) {
        if (value == null) return;
        setState(() => selectedEventId = value);
        context.read<ActiveEventProvider>().setFromUserPick(value);
      },
      onCancelCreate: _cancelCreateTeam,
      onSubmitCreate: selectedEvent == null || auth.user == null
          ? () {}
          : () => _createTeam(teams, selectedEvent, auth.user!),
      onShowCreateTeam: () => setState(() => showCreateTeam = true),
      onSubmitProject: () {
        final team = viewData.myTeamForSelectedEvent;
        if (team == null) return;
        context.go(
          RouteQuery.submitForTeam(
            team.id,
            eventId: selectedEventId,
          ),
        );
      },
    );
  }
}
