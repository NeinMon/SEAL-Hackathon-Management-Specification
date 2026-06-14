import '../../../shared.dart';
import 'judge_progress.dart';
import 'judge_submission_card.dart';
import 'judge_submission_selector.dart';

class JudgeContent extends StatefulWidget {
  const JudgeContent({super.key});

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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final submissionProvider = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final teamsProvider = context.watch<TeamProvider>();
    final teams = teamsProvider.teams;
    final submissions = _visibleSubmissions(
      submissionProvider.submissions,
      scores,
      teams,
    );
    final total = submissionProvider.submissions.length;
    final scored = submissionProvider.submissions
        .where((submission) => scores.scoreCountFor(submission.id) > 0)
        .length;
    final unscored = total - scored;
    final isJudge = auth.user?.role == 'judge';
    final loading =
        submissionProvider.isLoading ||
        scores.isLoading ||
        teamsProvider.isLoading;
    final selectedSubmission = _selectedSubmission(submissions);
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: AppStrings.judgeTitle,
          subtitle: AppStrings.judgeSubtitle,
          icon: Icons.rate_review_outlined,
          trailing: IconButton.filledTonal(
            tooltip: AppStrings.reloadJudgeQueueTooltip,
            onPressed: loading ? null : () => _refresh(context),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (!isJudge)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              child: Text(AppStrings.judgePreviewOnlyMessage),
            ),
          ),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (submissionProvider.error != null)
          StatusBanner(message: submissionProvider.error!, isError: true),
        if (scores.message != null) StatusBanner(message: scores.message!),
        JudgeProgress(total: total, scored: scored, unscored: unscored),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CommandChip(
              label: AppStrings.allFilter,
              selected: filter == 'all',
              onTap: () => setState(() => filter = 'all'),
            ),
            CommandChip(
              label: AppStrings.filterUnscored,
              selected: filter == 'unscored',
              onTap: () => setState(() => filter = 'unscored'),
              icon: Icons.pending_actions_outlined,
            ),
            CommandChip(
              label: AppStrings.filterScored,
              selected: filter == 'scored',
              onTap: () => setState(() => filter = 'scored'),
              icon: Icons.verified_outlined,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: search,
          decoration: InputDecoration(
            labelText: AppStrings.judgeSearchLabel,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: search.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: AppStrings.clearSearchAction,
                    onPressed: search.clear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: sort,
          decoration: const InputDecoration(
            labelText: AppStrings.judgeQueueSortLabel,
            prefixIcon: Icon(Icons.sort_outlined),
          ),
          items: const [
            DropdownMenuItem(
              value: 'queue',
              child: Text(AppStrings.sortNewestFirst),
            ),
            DropdownMenuItem(
              value: 'project',
              child: Text(AppStrings.sortProjectName),
            ),
            DropdownMenuItem(
              value: 'team',
              child: Text(AppStrings.sortTeamName),
            ),
            DropdownMenuItem(
              value: 'score',
              child: Text(AppStrings.sortAverageScore),
            ),
          ],
          onChanged: (value) => setState(() => sort = value ?? 'queue'),
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        if (loading)
          const LoadingCardList(itemCount: 3)
        else if (submissions.isEmpty)
          EmptyState(
            message: AppStrings.noMatchingSubmissions,
            actionLabel: AppStrings.showAllSubmissions,
            onAction: () => setState(() => filter = 'all'),
          )
        else ...[
          AdaptiveTwoPane(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                JudgeSubmissionSelector(
                  submissions: submissions,
                  scores: scores,
                  teams: teams,
                  value: selectedSubmission?.id,
                  onChanged: (value) =>
                      setState(() => selectedSubmissionId = value),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: unscored == 0
                      ? null
                      : () => _selectNextUnscored(
                          submissionProvider.submissions,
                          scores,
                          teams,
                        ),
                  icon: const Icon(Icons.skip_next_outlined),
                  label: const Text(AppStrings.nextUnscoredButton),
                ),
              ],
            ),
            trailing: selectedSubmission == null
                ? const EmptyState(message: AppStrings.selectSubmissionToScore)
                : JudgeSubmissionCard(
                    key: ValueKey('judge-card-${selectedSubmission.id}'),
                    submission: selectedSubmission,
                    scores: scores,
                    teams: teams,
                    judge: auth.user,
                    canSubmit: isJudge && !scores.isLoading,
                  ),
          ),
        ],
      ],
    );
  }

  Future<void> _refresh(BuildContext context) {
    return Future.wait([
      context.read<SubmissionProvider>().loadSubmissions(),
      context.read<ScoreProvider>().loadScores(),
      context.read<TeamProvider>().loadTeams(),
    ]);
  }

  List<ProjectSubmission> _visibleSubmissions(
    List<ProjectSubmission> all,
    ScoreProvider scores,
    List<Team> teams,
  ) {
    final filtered = all.where((submission) {
      final scored = scores.scoreCountFor(submission.id) > 0;
      final keyword = search.text.trim().toLowerCase();
      final teamName = _teamName(submission.teamId, teams).toLowerCase();
      final matchesSearch =
          keyword.isEmpty ||
          submission.projectName.toLowerCase().contains(keyword) ||
          submission.description.toLowerCase().contains(keyword) ||
          teamName.contains(keyword);
      final matchesFilter =
          filter == 'all' ||
          (filter == 'scored' && scored) ||
          (filter == 'unscored' && !scored);
      return matchesSearch && matchesFilter;
    }).toList();
    switch (sort) {
      case 'project':
        filtered.sort((a, b) => a.projectName.compareTo(b.projectName));
      case 'team':
        filtered.sort((a, b) => a.teamId.compareTo(b.teamId));
      case 'score':
        filtered.sort(
          (a, b) => scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
        );
      default:
        filtered.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    }
    return filtered;
  }

  ProjectSubmission? _selectedSubmission(List<ProjectSubmission> submissions) {
    if (submissions.isEmpty) return null;
    for (final submission in submissions) {
      if (submission.id == selectedSubmissionId) return submission;
    }
    return submissions.first;
  }

  void _selectNextUnscored(
    List<ProjectSubmission> all,
    ScoreProvider scores,
    List<Team> teams,
  ) {
    final queue = _visibleSubmissions(all, scores, teams);
    for (final submission in queue) {
      if (scores.scoreCountFor(submission.id) == 0) {
        setState(() => selectedSubmissionId = submission.id);
        return;
      }
    }
  }

  String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return AppStrings.unknownTeamLabel;
  }
}
