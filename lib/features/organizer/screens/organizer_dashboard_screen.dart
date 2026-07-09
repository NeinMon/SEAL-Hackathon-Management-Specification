import '../../../shared.dart';
import '../widgets/organizer_dashboard_content.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    if (!mounted) return;
    final eventId = RouteQuery.eventIdFrom(context);
    await Future.wait([
      context.read<EventProvider>().loadEvents(),
      context.read<TeamProvider>().loadTeams(eventId: eventId),
      context.read<SubmissionProvider>().loadSubmissions(eventId: eventId),
      context.read<ScoreProvider>().loadScores(eventId: eventId),
      context.read<ScoreProvider>().loadCriteria(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RoleGate(
      allowedRoles: const {AppRoles.organizer},
      message: L10nService.strings.organizerRoleGateMessage,
      child: OrganizerDashboardContent(onRefresh: _reload),
    );
  }
}
