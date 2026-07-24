import '../../../shared.dart';
import '../helpers/team_screen_view_data.dart';
import '../widgets/team_create_form.dart';
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
    BuildContext sheetContext,
    TeamProvider teams,
    HackathonEvent selectedEvent,
    AppUser user,
  ) async {
    if (!(_createFormKey.currentState?.validate() ?? false)) return;
    final teamName = name.text.trim();
    final notifications = context.read<NotificationProvider>();
    await teams.createTeam(teamName, selectedEvent, user);
    if (!mounted) return;
    if (teams.error == null) {
      name.clear();
      _createFormKey.currentState?.reset();
      if (sheetContext.mounted && Navigator.of(sheetContext).canPop()) {
        Navigator.of(sheetContext).pop();
      }
      await notifications.notifyTeamCreated(
        userId: user.id,
        teamName: teamName,
        eventTitle: selectedEvent.title,
        eventId: selectedEvent.id,
      );
    }
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
    return ActiveEventResolver.preferDefaultEvent(events);
  }

  void _openCreateTeamSheet({
    required List<HackathonEvent> events,
    required HackathonEvent? selectedEvent,
    required TeamScreenViewData viewData,
    required TeamProvider teams,
    required AppUser? user,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSizes.paddingMedium,
            right: AppSizes.paddingMedium,
            top: AppSizes.paddingCompact,
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom +
                AppSizes.paddingMedium,
          ),
          child: TeamCreateForm(
            formKey: _createFormKey,
            nameController: name,
            events: events,
            selectedEvent: selectedEvent,
            loading: viewData.loading,
            canCreateTeam: viewData.canCreateTeam,
            showCancel: true,
            user: user,
            onEventChanged: (value) {
              if (value == null) return;
              setState(() => selectedEventId = value);
              context.read<ActiveEventProvider>().setFromUserPick(value);
            },
            onCancel: () => Navigator.of(sheetContext).pop(),
            onSubmit: selectedEvent == null || user == null
                ? () {}
                : () => _createTeam(sheetContext, teams, selectedEvent, user),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final sortedEvents = events.sortedEvents;
    final selectedEvent = _selectedEvent(sortedEvents);
    final viewData = TeamScreenViewData.compute(
      user: auth.user,
      events: events,
      teams: teams,
      selectedEvent: selectedEvent,
      routeEventId: RouteQuery.eventIdFrom(context),
    );

    return TeamScreenBody(
      viewData: viewData,
      events: sortedEvents,
      teams: teams,
      eventsError: events.error,
      onRefresh: () => Future.wait([
        context.read<EventProvider>().loadEvents(),
        context.read<TeamProvider>().loadTeamWorkspace(auth.user),
      ]),
      onEventChanged: (value) {
        if (value == null) return;
        setState(() => selectedEventId = value);
        context.read<ActiveEventProvider>().setFromUserPick(value);
      },
      onShowCreateTeam: () => _openCreateTeamSheet(
        events: sortedEvents,
        selectedEvent: selectedEvent,
        viewData: viewData,
        teams: teams,
        user: auth.user,
      ),
    );
  }
}
