import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';
import 'judge_progress.dart';
import 'judge_queue_toolbar.dart';
import 'judge_queue_workspace.dart';

class JudgeContent extends StatefulWidget {
  const JudgeContent({super.key, this.eventId});

  final String? eventId;

  @override
  State<JudgeContent> createState() => _JudgeContentState();
}

class _JudgeContentState extends State<JudgeContent> {
  final search = TextEditingController();
  String filter = 'all';
  String sort = 'queue';
  String? selectedSubmissionId;

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

  void _selectNextUnscored(JudgeQueueViewData viewData) {
    final scores = context.read<ScoreProvider>();
    final teams = context.read<TeamProvider>().teams;
    final nextId = JudgeQueueViewData.nextUnscoredId(
      queueSource: viewData.queueSource,
      scores: scores,
      teams: teams,
      filter: filter,
      sort: sort,
      search: search,
    );
    if (nextId != null) {
      setState(() => selectedSubmissionId = nextId);
    }
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
      selectedSubmissionId: selectedSubmissionId,
    );
    final compact = MediaQuery.sizeOf(context).width < 640;

    final content = ListView(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingMedium,
        AppSizes.paddingMedium,
        AppSizes.paddingMedium,
        compact ? 96 : AppSizes.paddingMedium,
      ),
      children: [
        SealSectionHeader(
          title: viewData.filteredEvent == null
              ? L10nService.strings.judgeTitle
              : L10nService.strings.judgeQueueForEventTitle(
                  viewData.filteredEvent!.title,
                ),
          subtitle: viewData.filteredEvent == null
              ? L10nService.strings.judgeSubtitle
              : L10nService.strings.judgeQueueFilteredSubtitle,
          icon: Icons.rate_review_outlined,
          trailing: IconButton.filledTonal(
            tooltip: context.l10n.reloadJudgeQueueTooltip,
            onPressed: viewData.loading ? null : () => _refresh(context),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (!viewData.isJudge)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Text(context.l10n.judgePreviewOnlyMessage),
            ),
          ),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (submissionProvider.error != null)
          StatusBanner(message: submissionProvider.error!, isError: true),
        if (scores.message != null) StatusBanner(message: scores.message!),
        JudgeProgress(
          total: viewData.total,
          scored: viewData.scored,
          unscored: viewData.unscored,
        ),
        const SizedBox(height: 10),
        JudgeQueueToolbar(
          filter: filter,
          sort: sort,
          search: search,
          onFilterChanged: (value) => setState(() => filter = value),
          onSortChanged: (value) => setState(() => sort = value),
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        JudgeQueueWorkspace(
          viewData: viewData,
          eventId: widget.eventId,
          scores: scores,
          teams: teamsProvider.teams,
          events: events.events,
          judge: auth.user,
          selectedSubmissionId: selectedSubmissionId,
          onSubmissionSelected: (value) =>
              setState(() => selectedSubmissionId = value),
          onNextUnscored: () => _selectNextUnscored(viewData),
          onShowAllSubmissions: () => setState(() => filter = 'all'),
        ),
      ],
    );

    if (!compact || viewData.loading || viewData.submissions.isEmpty) {
      return content;
    }
    return Stack(
      children: [
        content,
        JudgeNextUnscoredBar(
          enabled: viewData.unscored > 0,
          onPressed: () => _selectNextUnscored(viewData),
        ),
      ],
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
