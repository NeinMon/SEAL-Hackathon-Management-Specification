import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';
import '../screens/judge_queue_screen.dart';
import '../screens/judge_score_screen.dart';

class JudgeContent extends StatefulWidget {
  const JudgeContent({super.key, this.eventId});

  final String? eventId;

  @override
  State<JudgeContent> createState() => _JudgeContentState();
}

class _JudgeContentState extends State<JudgeContent> {
  final search = TextEditingController();
  String filter = 'unscored';
  String sort = 'queue';

  @override
  void initState() {
    super.initState();
    search.addListener(_refreshSearch);
  }

  @override
  void dispose() {
    search
      ..removeListener(_refreshSearch)
      ..dispose();
    super.dispose();
  }

  void _refreshSearch() {
    if (mounted) setState(() {});
  }

  Future<void> _openSubmission(
    BuildContext context,
    ProjectSubmission submission,
    JudgeQueueViewData viewData,
  ) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (_) => JudgeScoreScreen(
          submissionId: submission.id,
          eventId: widget.eventId,
          filter: filter,
          sort: sort,
          search: search,
          queueSource: viewData.queueSource,
          onNextSelected: (_) => setState(() => filter = 'unscored'),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final submissionProvider = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final teamsProvider = context.watch<TeamProvider>();
    final events = context.watch<EventProvider>();
    final viewData = JudgeQueueViewData.compute(
      auth: auth,
      submissionProvider: submissionProvider,
      scores: scores,
      teamsProvider: teamsProvider,
      events: events,
      eventId: widget.eventId,
      filter: filter,
      sort: sort,
      search: search,
      selectedSubmissionId: null,
    );

    return JudgeQueueScreen(
      viewData: viewData,
      eventId: widget.eventId,
      filter: filter,
      sort: sort,
      search: search,
      submissionProvider: submissionProvider,
      scores: scores,
      teams: teamsProvider.teams,
      events: events.sortedEvents,
      onRefresh: () => _refresh(context),
      onFilterChanged: (value) => setState(() => filter = value),
      onSortChanged: (value) => setState(() => sort = value),
      onSubmissionTap: (submission) =>
          _openSubmission(context, submission, viewData),
      onShowUnscored: () => setState(
        () => filter = filter == 'unscored' ? 'scored' : 'unscored',
      ),
    );
  }

  Future<void> _refresh(BuildContext context) {
    final eventId = widget.eventId;
    return Future.wait([
      context.read<SubmissionProvider>().loadSubmissions(eventId: eventId),
      context.read<ScoreProvider>().loadScores(eventId: eventId),
      context.read<ScoreProvider>().loadCriteria(),
      context.read<TeamProvider>().loadTeams(eventId: eventId),
      context.read<EventProvider>().loadEvents(),
    ]);
  }
}
