import '../../../shared.dart';

class EventLeaderboard extends StatelessWidget {
  const EventLeaderboard({
    super.key,
    required this.submissions,
    required this.teams,
    required this.scores,
  });

  final List<ProjectSubmission> submissions;
  final List<Team> teams;
  final ScoreProvider scores;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          AppStrings.leaderboardTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (submissions.isEmpty)
          const EmptyState(message: AppStrings.noScoredSubmissionsYet)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final submission = submissions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: SealPalette.primary.withValues(
                      alpha: 0.14,
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: SealPalette.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  title: Text(submission.projectName),
                  subtitle: Text(
                    '${_teamName(submission.teamId, teams)}\n${AppStrings.scoreCountLabel(scores.scoreCountFor(submission.id))}',
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        scores.averageFor(submission.id).toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        AppStrings.averageScoreAbbrev,
                        style: TextStyle(
                          color: SealPalette.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return AppStrings.teamNotLoadedYet;
  }
}
