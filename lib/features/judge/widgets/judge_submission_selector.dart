import '../../../shared.dart';

class JudgeSubmissionSelector extends StatelessWidget {
  const JudgeSubmissionSelector({
    super.key,
    required this.submissions,
    required this.scores,
    required this.teams,
    required this.events,
    required this.value,
    required this.onChanged,
    this.showEventContext = true,
  });

  final List<ProjectSubmission> submissions;
  final ScoreProvider scores;
  final List<Team> teams;
  final List<HackathonEvent> events;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool showEventContext;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: context.sealPrimary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_turned_in_outlined,
                  color: context.sealPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    L10nService.strings.selectSubmissionTitle,
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
              L10nService.strings.submissionQueueCountLabel(submissions.length),
              style: TextStyle(color: context.sealTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: value ?? submissions.first.id,
              decoration: InputDecoration(
                labelText: L10nService.strings.judgeSubmissionToScoreLabel,
                prefixIcon: Icon(Icons.assignment_turned_in_outlined),
              ),
              items: [
                for (final submission in submissions)
                  DropdownMenuItem(
                    value: submission.id,
                    child: Text(
                      _submissionLabel(submission),
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

  String _submissionLabel(ProjectSubmission submission) {
    final teamName = _teamName(submission.teamId);
    if (!showEventContext) {
      return '${submission.projectName} • $teamName';
    }
    final eventTitle = EventScope.eventTitleForSubmission(
      submission: submission,
      teams: teams,
      events: events,
    );
    if (eventTitle == null) {
      return '${submission.projectName} • $teamName';
    }
    return '${submission.projectName} • $teamName • $eventTitle';
  }

  String _teamName(String teamId) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return L10nService.strings.unknownTeamLabel;
  }
}
