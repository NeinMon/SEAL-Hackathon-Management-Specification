import '../../shared.dart';

class JudgeScreen extends StatefulWidget {
  const JudgeScreen({super.key});

  @override
  State<JudgeScreen> createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
      context.read<TeamProvider>().loadTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const RoleGate(
      allowedRoles: AppRoles.scorers,
      message: 'Chỉ giám khảo và ban tổ chức mới truy cập được chấm điểm.',
      child: _JudgeContent(),
    );
  }
}

class _JudgeContent extends StatefulWidget {
  const _JudgeContent();

  @override
  State<_JudgeContent> createState() => _JudgeContentState();
}

class _JudgeContentState extends State<_JudgeContent> {
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
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Chấm điểm',
          subtitle: 'Chấm bài theo tiêu chí kỹ thuật, UI/UX và đổi mới.',
          icon: Icons.rate_review_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Tải lại hàng chờ chấm',
            onPressed: loading ? null : () => _refresh(context),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (!isJudge)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Đăng nhập role Giám khảo để gửi điểm chính thức. Ban tổ chức có thể xem trước màn này.',
              ),
            ),
          ),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (submissionProvider.error != null)
          StatusBanner(message: submissionProvider.error!, isError: true),
        if (scores.message != null) StatusBanner(message: scores.message!),
        _JudgeProgress(total: total, scored: scored, unscored: unscored),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CommandChip(
              label: 'Tất cả',
              selected: filter == 'all',
              onTap: () => setState(() => filter = 'all'),
            ),
            CommandChip(
              label: 'Chưa chấm',
              selected: filter == 'unscored',
              onTap: () => setState(() => filter = 'unscored'),
              icon: Icons.pending_actions_outlined,
            ),
            CommandChip(
              label: 'Đã chấm',
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
            labelText: 'Tìm bài nộp hoặc team',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: search.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Xóa tìm kiếm',
                    onPressed: search.clear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: sort,
          decoration: const InputDecoration(
            labelText: 'Sắp xếp hàng chờ',
            prefixIcon: Icon(Icons.sort_outlined),
          ),
          items: const [
            DropdownMenuItem(value: 'queue', child: Text('Mới nhất trước')),
            DropdownMenuItem(value: 'project', child: Text('Tên project')),
            DropdownMenuItem(value: 'team', child: Text('Team')),
            DropdownMenuItem(value: 'score', child: Text('Điểm trung bình')),
          ],
          onChanged: (value) => setState(() => sort = value ?? 'queue'),
        ),
        const SizedBox(height: 12),
        if (loading)
          const LoadingCardList(itemCount: 3)
        else if (submissions.isEmpty)
          EmptyState(
            message: 'Không có bài nộp phù hợp.',
            actionLabel: 'Hiện tất cả',
            onAction: () => setState(() => filter = 'all'),
          )
        else ...[
          AdaptiveTwoPane(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SubmissionSelector(
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
                  label: const Text('Bài chưa chấm tiếp theo'),
                ),
              ],
            ),
            trailing: selectedSubmission == null
                ? const EmptyState(message: 'Chọn một bài để chấm.')
                : _JudgeSubmissionCard(
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
    return 'Chưa rõ team';
  }
}

class _SubmissionSelector extends StatelessWidget {
  const _SubmissionSelector({
    required this.submissions,
    required this.scores,
    required this.teams,
    required this.value,
    required this.onChanged,
  });

  final List<ProjectSubmission> submissions;
  final ScoreProvider scores;
  final List<Team> teams;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: SealPalette.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: SealPalette.primary,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Chọn bài nộp',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                StatusPill(
                  label: '${submissions.length}',
                  icon: Icons.list_alt,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${submissions.length} bài trong hàng chờ này',
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: value ?? submissions.first.id,
              decoration: const InputDecoration(
                labelText: 'Bài cần chấm',
                prefixIcon: Icon(Icons.assignment_turned_in_outlined),
              ),
              items: [
                for (final submission in submissions)
                  DropdownMenuItem(
                    value: submission.id,
                    child: Text(
                      '${submission.projectName} - ${_teamName(submission.teamId)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: onChanged,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final submission in submissions.take(4))
                  ChoiceChip(
                    selected: (value ?? submissions.first.id) == submission.id,
                    label: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 180),
                      child: Text(
                        submission.projectName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    avatar: Icon(
                      scores.scoreCountFor(submission.id) == 0
                          ? Icons.pending_actions_outlined
                          : Icons.verified_outlined,
                      size: 18,
                    ),
                    onSelected: (_) => onChanged(submission.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _teamName(String teamId) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return 'Chưa rõ team';
  }
}

class _JudgeProgress extends StatelessWidget {
  const _JudgeProgress({
    required this.total,
    required this.scored,
    required this.unscored,
  });

  final int total;
  final int scored;
  final int unscored;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : scored / total;
    return Semantics(
      label: 'Tiến độ chấm: $scored đã chấm và $unscored chưa chấm',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SealPalette.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SealPalette.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tiến độ chấm',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(999),
                    color: unscored == 0
                        ? SealPalette.secondary
                        : SealPalette.primary,
                    backgroundColor: SealPalette.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusPill(
              label: '$scored/$total',
              color: unscored == 0
                  ? SealPalette.secondary
                  : SealPalette.tertiary,
              icon: Icons.fact_check_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _JudgeSubmissionCard extends StatefulWidget {
  const _JudgeSubmissionCard({
    super.key,
    required this.submission,
    required this.scores,
    required this.teams,
    required this.judge,
    required this.canSubmit,
  });

  final ProjectSubmission submission;
  final ScoreProvider scores;
  final List<Team> teams;
  final AppUser? judge;
  final bool canSubmit;

  @override
  State<_JudgeSubmissionCard> createState() => _JudgeSubmissionCardState();
}

class _JudgeSubmissionCardState extends State<_JudgeSubmissionCard> {
  double technical = 8;
  double ui = 8;
  double innovation = 9;
  final feedback = TextEditingController();
  String? inlineError;
  bool _hydratedExistingScore = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    feedback.addListener(_refreshFeedbackState);
    _hydrateFromExistingScore();
  }

  @override
  void didUpdateWidget(covariant _JudgeSubmissionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hydratedExistingScore) _hydrateFromExistingScore();
  }

  @override
  void dispose() {
    feedback
      ..removeListener(_refreshFeedbackState)
      ..dispose();
    super.dispose();
  }

  void _refreshFeedbackState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final submission = widget.submission;
    final judgeId = widget.judge?.id;
    final existingScore = judgeId == null
        ? null
        : widget.scores.scoreFor(submission.id, judgeId);
    final scoreCount = widget.scores.scoreCountFor(submission.id);
    final currentAverage = (technical + ui + innovation) / 3;
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SealPalette.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SealPalette.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusPill(
                        label: existingScore == null ? 'Cần chấm' : 'Đã chấm',
                        color: existingScore == null
                            ? SealPalette.tertiary
                            : SealPalette.secondary,
                        icon: existingScore == null
                            ? Icons.pending_actions_outlined
                            : Icons.verified_outlined,
                      ),
                      StatusPill(
                        label: '$scoreCount lượt chấm',
                        icon: Icons.leaderboard_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    submission.projectName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    submission.description,
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _openUrl(submission.githubUrl),
                        icon: const Icon(Icons.code_outlined),
                        label: const Text('Repository'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _openUrl(submission.videoUrl),
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Demo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const StatusBanner(
              message:
                  'Xem repository, chất lượng demo, độ sâu triển khai và tác động sản phẩm trước khi gửi điểm.',
            ),
            const Text(
              'Rubric Evaluation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _ScoreSlider(
              label: 'Technical depth',
              description:
                  'Kiến trúc, độ đúng, độ tin cậy và độ sâu triển khai.',
              icon: Icons.memory_outlined,
              value: technical,
              onChanged: (value) => setState(() => technical = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'UI/UX quality',
              description:
                  'Luồng mobile, độ rõ ràng, accessibility và độ hoàn thiện demo.',
              icon: Icons.design_services_outlined,
              value: ui,
              onChanged: (value) => setState(() => ui = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'Innovation',
              description:
                  'Tính mới, tác động, AI/automation hữu ích và độ phù hợp sản phẩm.',
              icon: Icons.auto_awesome_outlined,
              value: innovation,
              onChanged: (value) => setState(() => innovation = value),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feedback,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Feedback',
                prefixIcon: Icon(Icons.rate_review_outlined),
              ),
            ),
            if (inlineError != null) ...[
              const SizedBox(height: 8),
              Text(
                inlineError!,
                style: const TextStyle(
                  color: SealPalette.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 10),
            _ScoreSummaryCard(
              currentAverage: currentAverage,
              feedbackReady: feedback.text.trim().isNotEmpty,
              existingScore: existingScore,
              isSubmitting: isSubmitting,
              canSubmit: widget.canSubmit,
              onSubmit: _submitScore,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String value) async {
    await ExternalLauncher.openUrl(value);
  }

  Future<void> _submitScore() async {
    final judge = widget.judge;
    if (judge == null) return;
    final scoreError = AppValidators.scoreError(technical, ui, innovation);
    if (scoreError != null) {
      setState(() => inlineError = scoreError);
      return;
    }
    if (feedback.text.trim().isEmpty) {
      setState(() => inlineError = 'Cần nhập feedback trước khi gửi điểm.');
      return;
    }
    final existingScore = widget.scores.scoreFor(
      widget.submission.id,
      judge.id,
    );
    if (existingScore != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Cập nhật điểm cũ?'),
          content: Text(
            'Điểm trước đó của bạn cho ${widget.submission.projectName} sẽ được thay thế.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => inlineError = null);
    setState(() => isSubmitting = true);
    await widget.scores.addScore(
      ProjectScore(
        submissionId: widget.submission.id,
        judgeId: judge.id,
        technicalScore: technical,
        uiScore: ui,
        innovationScore: innovation,
        feedback: feedback.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => isSubmitting = false);
    if (widget.scores.error != null) return;
    Team? team;
    for (final item in widget.teams) {
      if (item.id == widget.submission.teamId) {
        team = item;
        break;
      }
    }
    final recipients =
        team?.members.map((member) => member.id).toSet() ?? {judge.id};
    for (final recipientId in recipients) {
      await context.read<NotificationProvider>().push(
        'Đã công bố điểm',
        '${widget.submission.projectName} có điểm mới.',
        'score',
        userId: recipientId,
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã công bố điểm.')));
  }

  void _hydrateFromExistingScore() {
    final judgeId = widget.judge?.id;
    if (judgeId == null) return;
    final existingScore = widget.scores.scoreFor(widget.submission.id, judgeId);
    if (existingScore == null) return;
    technical = existingScore.technicalScore;
    ui = existingScore.uiScore;
    innovation = existingScore.innovationScore;
    if (feedback.text.isEmpty) feedback.text = existingScore.feedback;
    _hydratedExistingScore = true;
  }
}

class _ScoreSlider extends StatelessWidget {
  const _ScoreSlider({
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label ${value.toStringAsFixed(1)} điểm. $description',
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: SealPalette.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SealPalette.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: SealPalette.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: SealPalette.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: const TextStyle(
                  color: SealPalette.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.25,
                ),
              ),
            ),
            SizedBox(
              height: 38,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Giảm',
                    onPressed: () => _step(-0.5),
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Slider(
                      value: value.clamp(0, 10).toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 20,
                      label: value.toStringAsFixed(1),
                      onChanged: (next) => onChanged(_rounded(next)),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tăng',
                    onPressed: () => _step(0.5),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _step(double delta) {
    onChanged(_rounded((value + delta).clamp(0, 10).toDouble()));
  }

  double _rounded(double raw) => double.parse(raw.toStringAsFixed(1));
}

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({
    required this.currentAverage,
    required this.feedbackReady,
    required this.existingScore,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onSubmit,
  });

  final double currentAverage;
  final bool feedbackReady;
  final ProjectScore? existingScore;
  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ScoreMetric(
                  label: 'Điểm hiện tại',
                  value: currentAverage.toStringAsFixed(1),
                  accent: SealPalette.tertiary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ScoreMetric(
                  label: 'Feedback',
                  value: feedbackReady ? 'Sẵn sàng' : 'Thiếu',
                  accent: feedbackReady
                      ? SealPalette.secondary
                      : SealPalette.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: !canSubmit || isSubmitting ? null : onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(existingScore == null ? 'Gửi điểm' : 'Cập nhật điểm'),
          ),
        ],
      ),
    );
  }
}

class _ScoreMetric extends StatelessWidget {
  const _ScoreMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: SealPalette.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
