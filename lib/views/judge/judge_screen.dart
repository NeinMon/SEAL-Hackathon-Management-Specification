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
  final technical = TextEditingController(text: '8');
  final ui = TextEditingController(text: '8');
  final innovation = TextEditingController(text: '9');
  final feedback = TextEditingController(
    text: 'Strong prototype with clear impact.',
  );

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
          title: 'Judge Console',
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
            Card(
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
                        color: SealPalette.primaryContainer.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: SealPalette.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: SealPalette.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'TEAM SUBMISSION',
                              style: TextStyle(
                                color: SealPalette.onSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const StatusBanner(
                      message:
                          'Review the repository, demo quality, implementation depth, and product impact before publishing a score.',
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rubric Evaluation',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: technical,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Technical',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: ui,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'UI/UX',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: innovation,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Innovation',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: feedback,
                      decoration: const InputDecoration(labelText: 'Feedback'),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 8),
                    Text(
                      'Average score: ${scores.averageFor(submission.id).toStringAsFixed(1)} / 10.0',
                      style: const TextStyle(
                        color: SealPalette.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: !isJudge
                          ? null
                          : () async {
                              final technicalScore = double.tryParse(
                                technical.text,
                              );
                              final uiScore = double.tryParse(ui.text);
                              final innovationScore = double.tryParse(
                                innovation.text,
                              );
                              final validScores =
                                  [
                                    technicalScore,
                                    uiScore,
                                    innovationScore,
                                  ].every(
                                    (score) =>
                                        score != null &&
                                        score >= 0 &&
                                        score <= 10,
                                  );
                              if (!validScores) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Scores must be between 0 and 10.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (feedback.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Feedback is required before publishing a score.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              await scores.addScore(
                                ProjectScore(
                                  submissionId: submission.id,
                                  judgeId: auth.user!.id,
                                  technicalScore: technicalScore!,
                                  uiScore: uiScore!,
                                  innovationScore: innovationScore!,
                                  feedback: feedback.text.trim(),
                                ),
                              );
                              if (!context.mounted) return;
                              Team? team;
                              for (final item in teams) {
                                if (item.id == submission.teamId) {
                                  team = item;
                                  break;
                                }
                              }
                              final recipients =
                                  team?.members
                                      .map((member) => member.id)
                                      .toSet() ??
                                  {if (auth.user != null) auth.user!.id};
                              for (final recipientId in recipients) {
                                await context.read<NotificationProvider>().push(
                                  'Score published',
                                  '${submission.projectName} has a new score.',
                                  'score',
                                  userId: recipientId,
                                );
                              }
                            },
                      icon: const Icon(Icons.check),
                      label: const Text('Submit score'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
