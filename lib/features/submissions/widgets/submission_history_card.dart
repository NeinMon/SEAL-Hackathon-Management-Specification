import '../../../shared.dart';

class SubmissionHistoryCard extends StatelessWidget {
  const SubmissionHistoryCard({
    super.key,
    required this.submission,
    required this.history,
    required this.scores,
  });

  final ProjectSubmission submission;
  final List<SubmissionHistory> history;
  final List<ProjectScore> scores;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code_outlined, color: SealPalette.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    submission.projectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
                StatusPill(
                  label: AppLabels.submissionStatus(submission.status),
                  icon: submission.status == 'reviewed'
                      ? Icons.verified_outlined
                      : Icons.task_alt_outlined,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatter.format(submission.submittedAt)}\n${submission.githubUrl}',
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                AppStrings.updateHistoryTitle,
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.take(3).length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Text(
                    '${formatter.format(item.changedAt)} - ${AppLabels.submissionStatus(item.status)} - ${item.projectName}',
                    style: const TextStyle(color: SealPalette.onSurfaceVariant),
                  );
                },
              ),
            ],
            if (scores.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                AppStrings.judgeFeedbackTitle,
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  final score = scores[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${score.average.toStringAsFixed(1)} - ${score.feedback}',
                      style: const TextStyle(
                        color: SealPalette.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
