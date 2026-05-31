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
      allowedRoles: {'judge', 'organizer'},
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
  final technical = TextEditingController(text: '8');
  final ui = TextEditingController(text: '8');
  final innovation = TextEditingController(text: '9');
  final feedback = TextEditingController();

  @override
  void dispose() {
    technical.dispose();
    ui.dispose();
    innovation.dispose();
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submission = widget.submission;
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
                  const StatusPill(
                    label: 'Submission',
                    color: SealPalette.secondary,
                    icon: Icons.assignment_turned_in_outlined,
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
            Row(
              children: [
                Expanded(
                  child: _ScoreField(label: 'Tech', controller: technical),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ScoreField(label: 'UI/UX', controller: ui),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ScoreField(label: 'Idea', controller: innovation),
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
            const SizedBox(height: 12),
            Text(
              'Average score: ${widget.scores.averageFor(submission.id).toStringAsFixed(1)} / 10.0',
              style: const TextStyle(
                color: SealPalette.primary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: !widget.canSubmit ? null : _submitScore,
              icon: const Icon(Icons.check),
              label: const Text('Submit score'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _submitScore() async {
    final judge = widget.judge;
    if (judge == null) return;
    final technicalScore = double.tryParse(technical.text);
    final uiScore = double.tryParse(ui.text);
    final innovationScore = double.tryParse(innovation.text);
    final validScores = [
      technicalScore,
      uiScore,
      innovationScore,
    ].every((score) => score != null && score >= 0 && score <= 10);
    if (!validScores) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scores must be between 0 and 10.')),
      );
      return;
    }
    if (feedback.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback is required before publishing a score.'),
        ),
      );
      return;
    }
    await widget.scores.addScore(
      ProjectScore(
        submissionId: widget.submission.id,
        judgeId: judge.id,
        technicalScore: technicalScore!,
        uiScore: uiScore!,
        innovationScore: innovationScore!,
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
}

class _ScoreField extends StatelessWidget {
  const _ScoreField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );
  }
}
