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
  ProjectSubmission? submission,
  ScoreProvider scores,
) {
  if (submission == null) {
    return const SubmissionStatusInfo(
      label: AppStrings.needsSubmissionStatus,
      helper: AppStrings.noProjectSubmittedHelper,
      color: SealPalette.tertiary,
      icon: Icons.pending_actions_outlined,
    );
  }
  final scoreCount = scores.scoreCountFor(submission.id);
  if (scoreCount > 0 || submission.status == 'reviewed') {
    return const SubmissionStatusInfo(
      label: AppStrings.reviewedStatus,
      helper: AppStrings.reviewedHelper,
      color: SealPalette.secondary,
      icon: Icons.verified_outlined,
    );
  }
  return const SubmissionStatusInfo(
    label: AppStrings.submittedStatus,
    helper: AppStrings.submittedHelper,
    color: SealPalette.primary,
    icon: Icons.task_alt_outlined,
  );
}

class SubmissionStatusCard extends StatelessWidget {
  const SubmissionStatusCard({
    super.key,
    required this.submission,
    required this.status,
    required this.scoreCount,
  });

  final ProjectSubmission? submission;
  final SubmissionStatusInfo status;
  final int scoreCount;

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
                    current?.projectName ?? AppStrings.notSubmittedYet,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    current == null
                        ? status.helper
                        : '${DateFormat('dd/MM HH:mm').format(current.submittedAt)} - ${AppStrings.scoreCountLabel(scoreCount)}',
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
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
