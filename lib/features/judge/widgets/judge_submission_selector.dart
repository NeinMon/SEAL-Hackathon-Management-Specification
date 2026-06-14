import '../../../shared.dart';

class JudgeSubmissionSelector extends StatelessWidget {
  const JudgeSubmissionSelector({
    super.key,
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
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
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
                    AppStrings.selectSubmissionTitle,
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
              AppStrings.submissionQueueCountLabel(submissions.length),
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: value ?? submissions.first.id,
              decoration: const InputDecoration(
                labelText: AppStrings.judgeSubmissionToScoreLabel,
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
    return AppStrings.unknownTeamLabel;
  }
}
