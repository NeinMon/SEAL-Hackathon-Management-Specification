import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared.dart';
import 'judge_rubric_controls.dart';
import 'judge_score_metric.dart';
import 'judge_score_summary_card.dart';
import 'judge_submission_header.dart';

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
    this.onNextUnscored,
    this.showBackNav = false,
  });

  final ProjectSubmission submission;
  final HackathonEvent? event;
  final List<HackathonEvent> events;
  final ScoreProvider scores;
  final List<Team> teams;
  final AppUser? judge;
  final bool canSubmit;
  final VoidCallback? onNextUnscored;
  final bool showBackNav;

  @override
  State<JudgeSubmissionCard> createState() => _JudgeSubmissionCardState();
}

class _JudgeSubmissionCardState extends State<JudgeSubmissionCard> {
  final Map<String, double> criterionScores = {};
  final feedback = TextEditingController();
  String? inlineError;
  bool _hydratedExistingScore = false;
  bool _hydratedDraft = false;
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
    if (oldWidget.submission.id != widget.submission.id) {
      _hydratedExistingScore = false;
      _hydratedDraft = false;
      criterionScores.clear();
      feedback.clear();
      inlineError = null;
      _hydrateFromExistingScore();
    } else if (!_hydratedExistingScore) {
      _hydrateFromExistingScore();
    }
  }

  @override
  void dispose() {
    feedback
      ..removeListener(_refreshFeedbackState)
      ..dispose();
    super.dispose();
  }

  void _refreshFeedbackState() {
    if (!mounted) return;
    setState(() {});
    _saveDraft();
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildScoringBody(context, includeSummary: false);
    final footer = _buildStickyFooter(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingCompact,
              AppSizes.paddingCompact,
              AppSizes.paddingCompact,
              AppSizes.paddingMedium,
            ),
            child: body,
          ),
        ),
        footer,
      ],
    );
  }

  Widget _buildScoringBody(BuildContext context, {required bool includeSummary}) {
    final submission = widget.submission;
    final judgeId = widget.judge?.id;
    final existingScore = judgeId == null
        ? null
        : widget.scores.scoreFor(submission.id, judgeId);
    final eventTitle =
        widget.event?.title ??
        EventScope.eventTitleForSubmission(
          submission: submission,
          teams: widget.teams,
          events: widget.events,
        );
    final judgingBlockReason = widget.event?.judgingBlockReason();
    final canSubmitScore =
        widget.canSubmit &&
        widget.event != null &&
        widget.event!.judgingOpen();
    final criteria = widget.scores.criteriaForEvent(widget.event?.id);
    _ensureCriterionScores(criteria);
    final currentAverage = _averageScore(criteria);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showBackNav)
          EmbeddedScreenHeader(
            title: submission.projectName,
            onBack: () => Navigator.of(context).pop(),
          ),
        JudgeSubmissionHeader(
          submission: submission,
          teamName: _teamName(submission.teamId),
          eventTitle: eventTitle,
          hasExistingScore: existingScore != null,
          scoreCount: widget.scores.scoreCountFor(submission.id),
          onOpenRepository: () => _openUrl(submission.githubUrl),
          onOpenDemo: () => _openUrl(submission.videoUrl),
          compact: true,
        ),
        const SizedBox(height: 14),
        if (judgingBlockReason != null) ...[
          const SizedBox(height: 8),
          StatusBanner(message: judgingBlockReason, isError: true),
        ],
        Text(
          L10nService.strings.rubricEvaluationTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        JudgeRubricControls(
          criteria: criteria,
          values: criterionScores,
          feedback: feedback,
          inlineError: inlineError,
          onChanged: (id, value) {
            setState(() => criterionScores[id] = value);
            _saveDraft();
          },
        ),
        if (includeSummary) ...[
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
      ],
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    final judgeId = widget.judge?.id;
    final existingScore = judgeId == null
        ? null
        : widget.scores.scoreFor(widget.submission.id, judgeId);
    final canSubmitScore =
        widget.canSubmit &&
        widget.event != null &&
        widget.event!.judgingOpen();
    final criteria = widget.scores.criteriaForEvent(widget.event?.id);
    _ensureCriterionScores(criteria);
    final currentAverage = _averageScore(criteria);

    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingCompact,
            8,
            AppSizes.paddingCompact,
            AppSizes.paddingCompact,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: JudgeScoreMetric(
                      label: L10nService.strings.currentScoreLabel,
                      value: currentAverage.toStringAsFixed(1),
                      accent: context.sealTertiary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: JudgeScoreMetric(
                      label: L10nService.strings.feedbackLabel,
                      value: feedback.text.trim().isNotEmpty
                          ? L10nService.strings.feedbackReady
                          : L10nService.strings.feedbackMissing,
                      accent: feedback.text.trim().isNotEmpty
                          ? context.sealSecondary
                          : context.sealError,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: !canSubmitScore || isSubmitting ? null : _submitScore,
                icon: isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  existingScore == null
                      ? L10nService.strings.submitScoreButton
                      : L10nService.strings.updateScoreButton,
                ),
              ),
              if (widget.onNextUnscored != null) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: widget.onNextUnscored,
                  icon: const Icon(Icons.skip_next_outlined),
                  label: Text(context.l10n.nextUnscoredButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _teamName(String teamId) {
    for (final team in widget.teams) {
      if (team.id == teamId) return team.name;
    }
    return L10nService.strings.unknownTeamLabel;
  }

  Future<void> _openUrl(String value) async {
    final opened = await ExternalLauncher.openUrl(value);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.openExternalLinkFailed)),
      );
    }
  }

  Future<void> _submitScore() async {
    final judge = widget.judge;
    if (judge == null) return;
    final validationError = _scoreValidationError();
    if (validationError != null) {
      setState(() => inlineError = validationError);
      return;
    }
    final existingScore = widget.scores.scoreFor(
      widget.submission.id,
      judge.id,
    );
    if (existingScore != null && !await _confirmScoreUpdate()) return;

    setState(() {
      inlineError = null;
      isSubmitting = true;
    });
    final score = ProjectScore(
      submissionId: widget.submission.id,
      judgeId: judge.id,
      technicalScore: _legacyScoreAt(0),
      uiScore: _legacyScoreAt(1),
      innovationScore: _legacyScoreAt(2),
      feedback: feedback.text.trim(),
      criteriaScores: _scoresForCurrentCriteria(),
    );
    await widget.scores.addScore(score, event: widget.event);
    if (!mounted) return;
    setState(() => isSubmitting = false);
    if (widget.scores.error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(widget.scores.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      return;
    }

    await _clearDraft();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.scorePublishedWithHintSnackBar)),
      );
    Navigator.of(context).pop();
  }

  String? _scoreValidationError() {
    return AppValidators.scoreValues(_scoresForCurrentCriteria().values) ??
        (feedback.text.trim().isEmpty
            ? L10nService.strings.validationFeedbackRequired
            : null);
  }

  Future<bool> _confirmScoreUpdate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.updateScoreDialogTitle),
        content: Text(
          L10nService.strings.updateScoreDialogBody(widget.submission.projectName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.updateButton),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  void _hydrateFromExistingScore() {
    final judgeId = widget.judge?.id;
    if (judgeId == null) return;
    final existingScore = widget.scores.scoreFor(widget.submission.id, judgeId);
    if (existingScore == null) return;
    final existingCriteriaScores = existingScore.criteriaScores;
    if (existingCriteriaScores.isNotEmpty) {
      criterionScores
        ..clear()
        ..addAll(existingCriteriaScores);
    } else {
      criterionScores
        ..clear()
        ..addAll({
          'technical': existingScore.technicalScore,
          'ui': existingScore.uiScore,
          'innovation': existingScore.innovationScore,
        });
    }
    if (feedback.text.isEmpty) feedback.text = existingScore.feedback;
    _hydratedExistingScore = true;
  }

  void _ensureCriterionScores(List<ScoreCriterion> criteria) {
    for (final criterion in criteria) {
      criterionScores.putIfAbsent(criterion.id, () => 8);
    }
    criterionScores.removeWhere(
      (id, _) => !criteria.any((criterion) => criterion.id == id),
    );
    if (!_hydratedExistingScore && !_hydratedDraft) {
      _hydrateDraft();
    }
  }

  Map<String, double> _scoresForCurrentCriteria() {
    final criteria = widget.scores.criteriaForEvent(widget.event?.id);
    _ensureCriterionScores(criteria);
    return {
      for (final criterion in criteria)
        criterion.id: criterionScores[criterion.id] ?? 8,
    };
  }

  double _averageScore(List<ScoreCriterion> criteria) {
    return ScoreCriterion.weightedAverage(_scoresForCurrentCriteria(), criteria);
  }

  double _legacyScoreAt(int index) {
    final values = _scoresForCurrentCriteria().values.toList();
    if (index >= values.length) return values.isEmpty ? 0 : values.last;
    return values[index];
  }

  String? get _draftKey {
    final judgeId = widget.judge?.id;
    if (judgeId == null) return null;
    return 'judge_draft_${judgeId}_${widget.submission.id}';
  }

  Future<void> _hydrateDraft() async {
    final key = _draftKey;
    if (key == null || _hydratedDraft || _hydratedExistingScore) return;
    _hydratedDraft = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty || !mounted) return;
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      await prefs.remove(key);
      return;
    }
    if (decoded is! Map<String, dynamic>) return;
    final data = decoded;
    final rawScores = data['scores'];
    if (rawScores is! Map) return;
    setState(() {
      criterionScores
        ..clear()
        ..addAll(
          rawScores.map(
            (key, value) =>
                MapEntry(key.toString(), value is num ? value.toDouble() : 8.0),
          ),
        );
      feedback.text = (data['feedback'] ?? '').toString();
    });
  }

  Future<void> _saveDraft() async {
    final key = _draftKey;
    if (key == null || _hydratedExistingScore || isSubmitting) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode({
        'scores': _scoresForCurrentCriteria(),
        'feedback': feedback.text,
      }),
    );
  }

  Future<void> _clearDraft() async {
    final key = _draftKey;
    if (key == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
