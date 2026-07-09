import '../../../shared.dart';
import '../helpers/event_detail_view_data.dart';
import '../widgets/event_detail_body.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});
  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveEventProvider>().setFromUserPick(widget.eventId);
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<EventProvider>().loadEvents(),
      context.read<TeamProvider>().loadTeams(eventId: widget.eventId),
      context.read<SubmissionProvider>().loadSubmissions(
        eventId: widget.eventId,
      ),
      context.read<ScoreProvider>().loadScores(eventId: widget.eventId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final event = eventProvider.byIdOrNull(widget.eventId);
    if (event == null) {
      return EventDetailMissingView(
        isLoading: eventProvider.isLoading,
        error: eventProvider.error,
      );
    }

    final viewData = EventDetailViewData.compute(
      event: event,
      teams: context.watch<TeamProvider>().teams,
      submissions: context.watch<SubmissionProvider>().submissions,
      scores: context.watch<ScoreProvider>(),
      user: context.watch<AuthProvider>().user,
    );

    return EventDetailBody(
      event: event,
      viewData: viewData,
      scores: context.watch<ScoreProvider>(),
      role: context.watch<AuthProvider>().user?.role,
      onRefresh: _refresh,
    );
  }
}
