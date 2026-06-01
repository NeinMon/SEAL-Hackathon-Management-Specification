part of '../../main.dart';

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
      message: 'Only judges and organizers can access scoring.',
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
  String filter = 'all';
  String sort = 'queue';
  String? selectedSubmissionId;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final submissionProvider = context.watch<SubmissionProvider>();
    final submissions = _visibleSubmissions(
      submissionProvider.submissions,
      context.watch<ScoreProvider>(),
    );
    final scores = context.watch<ScoreProvider>();
    final teamsProvider = context.watch<TeamProvider>();
    final teams = teamsProvider.teams;
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
          title: 'Judging',
          subtitle:
              'Score submissions with technical, UI/UX, and innovation criteria.',
          icon: Icons.rate_review_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Refresh judging queue',
            onPressed: loading ? null : () => _refresh(context),
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (!isJudge)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Login with role Judge to submit official scores. You can still preview the screen.',
              ),
            ),
          ),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (submissionProvider.error != null)
          StatusBanner(message: submissionProvider.error!, isError: true),
        if (scores.message != null) StatusBanner(message: scores.message!),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CommandChip(
              label: 'All',
              selected: filter == 'all',
              onTap: () => setState(() => filter = 'all'),
            ),
            CommandChip(
              label: 'Unscored',
              selected: filter == 'unscored',
              onTap: () => setState(() => filter = 'unscored'),
              icon: Icons.pending_actions_outlined,
            ),
            CommandChip(
              label: 'Scored',
              selected: filter == 'scored',
              onTap: () => setState(() => filter = 'scored'),
              icon: Icons.verified_outlined,
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: sort,
          decoration: const InputDecoration(
            labelText: 'Sort queue',
            prefixIcon: Icon(Icons.sort_outlined),
          ),
          items: const [
            DropdownMenuItem(value: 'queue', child: Text('Newest first')),
            DropdownMenuItem(value: 'project', child: Text('Project name')),
            DropdownMenuItem(value: 'team', child: Text('Team')),
            DropdownMenuItem(value: 'score', child: Text('Average score')),
          ],
          onChanged: (value) => setState(() => sort = value ?? 'queue'),
        ),
        const SizedBox(height: 14),
        if (loading)
          const LoadingCardList(itemCount: 3)
        else if (submissions.isEmpty)
          EmptyState(
            message: 'No submissions match this queue',
            actionLabel: 'Show all',
            onAction: () => setState(() => filter = 'all'),
          )
        else ...[
          _SubmissionSelector(
            submissions: submissions,
            scores: scores,
            teams: teams,
            value: selectedSubmission?.id,
            onChanged: (value) => setState(() => selectedSubmissionId = value),
          ),
          const SizedBox(height: 12),
          if (selectedSubmission != null)
            _JudgeSubmissionCard(
              key: ValueKey('judge-card-${selectedSubmission.id}'),
              submission: selectedSubmission,
              scores: scores,
              teams: teams,
              judge: auth.user,
              canSubmit: isJudge && !scores.isLoading,
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
  ) {
    final filtered = all.where((submission) {
      final scored = scores.scoreCountFor(submission.id) > 0;
      return filter == 'all' ||
          (filter == 'scored' && scored) ||
          (filter == 'unscored' && !scored);
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select submission',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '${submissions.length} submission${submissions.length == 1 ? '' : 's'} in this queue',
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: value ?? submissions.first.id,
              decoration: const InputDecoration(
                labelText: 'Submission to score',
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
            const SizedBox(height: 10),
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
    return 'Unknown team';
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
    _hydrateFromExistingScore();
  }

  @override
  void didUpdateWidget(covariant _JudgeSubmissionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hydratedExistingScore) _hydrateFromExistingScore();
  }

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
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
                        label: existingScore == null
                            ? 'Needs review'
                            : 'Already scored',
                        color: existingScore == null
                            ? SealPalette.tertiary
                            : SealPalette.secondary,
                        icon: existingScore == null
                            ? Icons.pending_actions_outlined
                            : Icons.verified_outlined,
                      ),
                      StatusPill(
                        label: '$scoreCount score${scoreCount == 1 ? '' : 's'}',
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
                  'Review the repository, demo quality, implementation depth, and product impact before publishing a score.',
            ),
            const Text(
              'Rubric Evaluation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _ScoreSlider(
              label: 'Technical depth',
              description:
                  'Architecture, correctness, reliability, and implementation depth.',
              icon: Icons.memory_outlined,
              value: technical,
              onChanged: (value) => setState(() => technical = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'UI/UX quality',
              description:
                  'Mobile flow, clarity, accessibility, and demo polish.',
              icon: Icons.design_services_outlined,
              value: ui,
              onChanged: (value) => setState(() => ui = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'Innovation',
              description:
                  'Originality, impact, useful AI/automation, and product fit.',
              icon: Icons.auto_awesome_outlined,
              value: innovation,
              onChanged: (value) => setState(() => innovation = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ScoreMetric(
                    label: 'Current score',
                    value: currentAverage.toStringAsFixed(1),
                    accent: SealPalette.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ScoreMetric(
                    label: 'Published avg',
                    value: widget.scores
                        .averageFor(submission.id)
                        .toStringAsFixed(1),
                    accent: SealPalette.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: !widget.canSubmit || isSubmitting
                  ? null
                  : _submitScore,
              icon: isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                existingScore == null ? 'Submit score' : 'Update score',
              ),
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
      setState(
        () => inlineError = 'Feedback is required before publishing a score.',
      );
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
          title: const Text('Update existing score?'),
          content: Text(
            'This will replace your previous score for ${widget.submission.projectName}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Update'),
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
        'Score published',
        '${widget.submission.projectName} has a new score.',
        'score',
        userId: recipientId,
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Score published.')));
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
          const SizedBox(height: 6),
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
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease',
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
                tooltip: 'Increase',
                onPressed: () => _step(0.5),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _step(double delta) {
    onChanged(_rounded((value + delta).clamp(0, 10).toDouble()));
  }

  double _rounded(double raw) => double.parse(raw.toStringAsFixed(1));
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
