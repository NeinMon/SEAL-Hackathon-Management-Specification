import '../../../shared.dart';
import 'judge_score_slider.dart';
import 'judge_score_summary_card.dart';

class JudgeSubmissionCard extends StatefulWidget {
  const JudgeSubmissionCard({
    super.key,
    required this.submission,
    required this.event,
    required this.events,
    required this.scores,
    required this.teams,
    required this.judge,
    required this.canSubmit,
  });

  final ProjectSubmission submission;
  final HackathonEvent? event;
  final List<HackathonEvent> events;
  final ScoreProvider scores;
  final List<Team> teams;
  final AppUser? judge;
  final bool canSubmit;

  @override
  State<JudgeSubmissionCard> createState() => _JudgeSubmissionCardState();
}

class _JudgeSubmissionCardState extends State<JudgeSubmissionCard> {
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
  void didUpdateWidget(covariant JudgeSubmissionCard oldWidget) {
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
    final eventTitle =
        widget.event?.title ??
        EventScope.eventTitleForSubmission(
          submission: submission,
          teams: widget.teams,
          events: widget.events,
        );
    final existingScore = judgeId == null
        ? null
        : widget.scores.scoreFor(submission.id, judgeId);
    final scoreCount = widget.scores.scoreCountFor(submission.id);
    final currentAverage = (technical + ui + innovation) / 3;
    final judgingBlockReason = widget.event?.judgingBlockReason();
    final canSubmitScore =
        widget.canSubmit &&
        (widget.event == null || widget.event!.judgingOpen());
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
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
                            ? AppStrings.needsScoringBadge
                            : AppStrings.filterScored,
                        color: existingScore == null
                            ? SealPalette.tertiary
                            : SealPalette.secondary,
                        icon: existingScore == null
                            ? Icons.pending_actions_outlined
                            : Icons.verified_outlined,
                      ),
                      StatusPill(
                        label: AppStrings.scoreCountLabel(scoreCount),
                        icon: Icons.leaderboard_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    submission.projectName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: context.onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_teamName(submission.teamId)} • ${eventTitle ?? AppStrings.eventNotLoadedYet}',
                    style: TextStyle(
                      color: context.sealTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    submission.description,
                    style: TextStyle(
                      color: context.sealTheme.onSurfaceVariant,
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
                        label: const Text(AppStrings.repositoryButton),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _openUrl(submission.videoUrl),
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text(AppStrings.demoButton),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const StatusBanner(message: AppStrings.judgeReviewReminder),
            if (judgingBlockReason != null) ...[
              const SizedBox(height: 8),
              StatusBanner(message: judgingBlockReason, isError: true),
            ],
            const Text(
              AppStrings.rubricEvaluationTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            JudgeScoreSlider(
              label: AppStrings.rubricTechnicalLabel,
              description: AppStrings.rubricTechnicalDescription,
              icon: Icons.memory_outlined,
              value: technical,
              onChanged: (value) => setState(() => technical = value),
            ),
            const SizedBox(height: 10),
            JudgeScoreSlider(
              label: AppStrings.rubricUiLabel,
              description: AppStrings.rubricUiDescription,
              icon: Icons.design_services_outlined,
              value: ui,
              onChanged: (value) => setState(() => ui = value),
            ),
            const SizedBox(height: 10),
            JudgeScoreSlider(
              label: AppStrings.rubricInnovationLabel,
              description: AppStrings.rubricInnovationDescription,
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
                labelText: AppStrings.feedbackLabel,
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
            JudgeScoreSummaryCard(
              currentAverage: currentAverage,
              feedbackReady: feedback.text.trim().isNotEmpty,
              existingScore: existingScore,
              isSubmitting: isSubmitting,
              canSubmit: canSubmitScore,
              onSubmit: _submitScore,
            ),
          ],
        ),
      ),
    );
  }

  String _teamName(String teamId) {
    for (final team in widget.teams) {
      if (team.id == teamId) return team.name;
    }
    return AppStrings.unknownTeamLabel;
  }

  Future<void> _openUrl(String value) async {
    final opened = await ExternalLauncher.openUrl(value);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể mở liên kết trên thiết bị này.'),
        ),
      );
    }
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
      setState(() => inlineError = AppStrings.validationFeedbackRequired);
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
          title: const Text(AppStrings.updateScoreDialogTitle),
          content: Text(
            AppStrings.updateScoreDialogBody(widget.submission.projectName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.updateButton),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => inlineError = null);
    setState(() => isSubmitting = true);
    final score = ProjectScore(
      submissionId: widget.submission.id,
      judgeId: judge.id,
      technicalScore: technical,
      uiScore: ui,
      innovationScore: innovation,
      feedback: feedback.text.trim(),
    );
    await widget.scores.addScore(score, event: widget.event);
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
    if (team == null || team.members.isEmpty) {
      try {
        final freshTeams = await const TeamService().fetchTeams();
        for (final item in freshTeams) {
          if (item.id == widget.submission.teamId) {
            team = item;
            break;
          }
        }
      } catch (_) {
        // Keep the in-memory team if the refresh fails.
      }
    }
    if (!mounted) return;
    final recipients = <String>{};
    if (team != null) {
      recipients.addAll(team.members.map((member) => member.id));
      recipients.add(team.leaderId);
    }
    recipients.removeWhere((id) => id.isEmpty);
    if (recipients.isEmpty) {
      recipients.add(judge.id);
    }
    if (!mounted) return;
    final notifications = context.read<NotificationProvider>();
    for (final recipientId in recipients) {
      await notifications.push(
        AppStrings.scorePublishedNotificationTitle,
        AppStrings.scorePublishedNotificationBody(
          widget.submission.projectName,
          average: score.average,
          feedback: score.feedback,
        ),
        'score',
        userId: recipientId,
      );
    }
    if (!mounted) return;
    if (notifications.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(notifications.error!)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.scorePublishedSnackBar)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.judgeScoreParticipantHint)),
    );
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
