import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';
import '../widgets/judge_submission_card.dart';

class JudgeScoreScreen extends StatefulWidget {
  const JudgeScoreScreen({
    super.key,
    required this.submissionId,
    required this.eventId,
    required this.filter,
    required this.sort,
    required this.search,
    required this.queueSource,
    required this.onNextSelected,
  });

  final String submissionId;
  final String? eventId;
  final String filter;
  final String sort;
  final TextEditingController search;
  final List<ProjectSubmission> queueSource;
  final ValueChanged<String?> onNextSelected;

  @override
  State<JudgeScoreScreen> createState() => _JudgeScoreScreenState();
}

class _JudgeScoreScreenState extends State<JudgeScoreScreen> {
  static const _reviewHintKey = 'judge_review_hint_shown_v1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowReviewHint());
  }

  Future<void> _maybeShowReviewHint() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_reviewHintKey) == true) return;
    await prefs.setBool(_reviewHintKey, true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10nService.strings.judgeReviewReminder)),
    );
  }

  ProjectSubmission? _submission(SubmissionProvider submissions) {
    for (final submission in submissions.submissions) {
      if (submission.id == widget.submissionId) return submission;
    }
    for (final submission in widget.queueSource) {
      if (submission.id == widget.submissionId) return submission;
    }
    return null;
  }

  void _goNextUnscored() {
    final scores = context.read<ScoreProvider>();
    final teams = context.read<TeamProvider>().teams;
    final nextId = JudgeQueueViewData.nextUnscoredId(
      queueSource: widget.queueSource,
      scores: scores,
      teams: teams,
      sort: widget.sort,
      search: widget.search,
    );
    if (nextId == null || nextId == widget.submissionId) return;
    widget.onNextSelected(nextId);
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JudgeScoreScreen(
          submissionId: nextId,
          eventId: widget.eventId,
          filter: widget.filter,
          sort: widget.sort,
          search: widget.search,
          queueSource: widget.queueSource,
          onNextSelected: widget.onNextSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final teams = context.watch<TeamProvider>().teams;
    final events = context.watch<EventProvider>().events;
    final submission = _submission(submissions);
    final canGoNext = JudgeQueueViewData.nextUnscoredId(
          queueSource: widget.queueSource,
          scores: scores,
          teams: teams,
          sort: widget.sort,
          search: widget.search,
        ) !=
        null;

    final barTitle = submission == null
        ? L10nService.strings.judgeNavLabel
        : _teamName(submission.teamId, teams);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppSizes.topChromeHeight(context),
        title: Text(barTitle),
      ),
      body: submission == null
          ? EmptyState(
              message: L10nService.strings.noMatchingSubmissions,
              actionLabel: L10nService.strings.submitWizardBack,
              onAction: () => Navigator.of(context).pop(),
            )
          : JudgeSubmissionCard(
              key: ValueKey('judge-score-${submission.id}'),
              submission: submission,
              event: JudgeQueueViewData.eventForSubmission(
                submission,
                teams,
                context.read<EventProvider>(),
              ),
              events: events,
              scores: scores,
              teams: teams,
              judge: auth.user,
              canSubmit: auth.user?.role == AppRoles.judge && !scores.isLoading,
              onNextUnscored: canGoNext ? _goNextUnscored : null,
            ),
    );
  }

  String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return L10nService.strings.unknownTeamLabel;
  }
}
