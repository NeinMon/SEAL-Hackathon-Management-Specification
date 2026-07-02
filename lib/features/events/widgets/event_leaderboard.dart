import '../../../shared.dart';

class EventLeaderboard extends StatelessWidget {
  const EventLeaderboard({
    super.key,
    required this.scoredSubmissions,
    required this.pendingSubmissions,
    required this.hasSubmissions,
    required this.teams,
    required this.scores,
  });

  final List<ProjectSubmission> scoredSubmissions;
  final List<ProjectSubmission> pendingSubmissions;
  final bool hasSubmissions;
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
        if (scoredSubmissions.isEmpty)
          EmptyState(
            message: hasSubmissions
                ? AppStrings.noScoredSubmissionsYet
                : AppStrings.noSubmissionsForEventYet,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: scoredSubmissions.length,
            itemBuilder: (context, index) => _LeaderboardTile(
              rank: index + 1,
              submission: scoredSubmissions[index],
              teamName: _teamName(scoredSubmissions[index].teamId, teams),
              average: scores.averageFor(scoredSubmissions[index].id),
              scoreCount: scores.scoreCountFor(scoredSubmissions[index].id),
            ),
          ),
        if (pendingSubmissions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            AppStrings.leaderboardPendingTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.onSurfaceColor,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingSubmissions.length,
            itemBuilder: (context, index) {
              final submission = pendingSubmissions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.hourglass_top_outlined, size: 18),
                  ),
                  title: Text(submission.projectName),
                  subtitle: Text(_teamName(submission.teamId, teams)),
                  trailing: const StatusPill(
                    label: AppStrings.awaitingScoreBadge,
                    color: SealPalette.tertiary,
                    icon: Icons.pending_outlined,
                  ),
                ),
              );
            },
          ),
        ],
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

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({
    required this.rank,
    required this.submission,
    required this.teamName,
    required this.average,
    required this.scoreCount,
  });

  final int rank;
  final ProjectSubmission submission;
  final String teamName;
  final double average;
  final int scoreCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: SealPalette.primary.withValues(alpha: 0.14),
          child: Text(
            '#$rank',
            style: const TextStyle(
              color: SealPalette.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text(submission.projectName),
        subtitle: Text('$teamName\n${AppStrings.scoreCountLabel(scoreCount)}'),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              average.toStringAsFixed(1),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            Text(
              AppStrings.averageScoreAbbrev,
              style: TextStyle(
                color: context.sealTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
