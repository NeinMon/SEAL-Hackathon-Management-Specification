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
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final submissions = context.watch<SubmissionProvider>().submissions;
    final scores = context.watch<ScoreProvider>();
    final teams = context.watch<TeamProvider>().teams;
    final isJudge = auth.user?.role == 'judge';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Judging',
          subtitle:
              'Score submissions with technical, UI/UX, and innovation criteria.',
          icon: Icons.rate_review_outlined,
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
        if (scores.message != null) StatusBanner(message: scores.message!),
        if (scores.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (submissions.isEmpty)
          const EmptyState(message: 'No submissions to score')
        else
          for (final submission in submissions)
            _JudgeSubmissionCard(
              submission: submission,
              scores: scores,
              teams: teams,
              judge: auth.user,
              canSubmit: isJudge,
            ),
      ],
    );
  }
}

class _JudgeSubmissionCard extends StatefulWidget {
  const _JudgeSubmissionCard({
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
              icon: Icons.memory_outlined,
              value: technical,
              onChanged: (value) => setState(() => technical = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'UI/UX quality',
              icon: Icons.design_services_outlined,
              value: ui,
              onChanged: (value) => setState(() => ui = value),
            ),
            const SizedBox(height: 10),
            _ScoreSlider(
              label: 'Innovation',
              icon: Icons.auto_awesome_outlined,
              value: innovation,
              onChanged: (value) => setState(() => innovation = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ScoreMetric(
                    label: 'Draft score',
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
              onPressed: !widget.canSubmit ? null : _submitScore,
              icon: const Icon(Icons.check),
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
    setState(() => inlineError = null);
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
    if (!mounted || widget.scores.error != null) return;
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
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
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
