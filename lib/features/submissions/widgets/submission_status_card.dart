import '../../../shared.dart';

class SubmissionStatusInfo {
  const SubmissionStatusInfo({
    required this.label,
    required this.helper,
    required this.color,
    required this.icon,
  });

  final String label;
  final String helper;
  final Color color;
  final IconData icon;
}

SubmissionStatusInfo resolveSubmissionStatus(
  BuildContext context,
  ProjectSubmission? submission,
  ScoreProvider scores,
) {
  if (submission == null) {
    return SubmissionStatusInfo(
      label: L10nService.strings.needsSubmissionStatus,
      helper: L10nService.strings.noProjectSubmittedHelper,
      color: context.sealTertiary,
      icon: Icons.pending_actions_outlined,
    );
  }
  final scoreCount = scores.scoreCountFor(submission.id);
  if (scoreCount > 0 || submission.status == 'reviewed') {
    return SubmissionStatusInfo(
      label: L10nService.strings.reviewedStatus,
      helper: L10nService.strings.reviewedHelper,
      color: context.sealSecondary,
      icon: Icons.verified_outlined,
    );
  }
  return SubmissionStatusInfo(
    label: L10nService.strings.submittedStatus,
    helper: L10nService.strings.submittedHelper,
    color: context.sealPrimary,
    icon: Icons.task_alt_outlined,
  );
}

class SubmissionStatusCard extends StatelessWidget {
  const SubmissionStatusCard({
    super.key,
    required this.submission,
    required this.status,
    required this.scoreCount,
    this.averageScore,
    this.highlightScore = false,
  });

  final ProjectSubmission? submission;
  final SubmissionStatusInfo status;
  final int scoreCount;
  final double? averageScore;
  final bool highlightScore;

  @override
  Widget build(BuildContext context) {
    final current = submission;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: status.color.withValues(alpha: 0.42)),
              ),
              child: Icon(status.icon, color: status.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusPill(
                    label: status.label,
                    color: status.color,
                    icon: status.icon,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current?.projectName ?? L10nService.strings.notSubmittedYet,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    current == null
                        ? status.helper
                        : averageScore != null
                        ? context.l10n.journeyScoreSummaryFormatted(averageScore!)
                        : '${DateFormat('dd/MM HH:mm').format(current.submittedAt)} - ${L10nService.strings.scoreCountLabel(scoreCount)}',
                    style: TextStyle(
                      color: highlightScore && averageScore != null
                          ? context.sealSecondary
                          : context.sealTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: highlightScore && averageScore != null ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
