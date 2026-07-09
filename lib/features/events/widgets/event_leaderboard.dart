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
        Text(
          L10nService.strings.leaderboardTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (scoredSubmissions.isEmpty)
          EmptyState(
            message: hasSubmissions
                ? L10nService.strings.noScoredSubmissionsYet
                : L10nService.strings.noSubmissionsForEventYet,
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
            L10nService.strings.leaderboardPendingTitle,
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
              return _LeaderboardPendingTile(
                submission: submission,
                teamName: _teamName(submission.teamId, teams),
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
    return L10nService.strings.teamNotLoadedYet;
  }
}

class _LeaderboardPendingTile extends StatelessWidget {
  const _LeaderboardPendingTile({
    required this.submission,
    required this.teamName,
  });

  final ProjectSubmission submission;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.hourglass_top_outlined, size: 18),
        ),
        title: Text(submission.projectName),
        subtitle: Text(teamName),
        trailing: StatusPill(
          label: L10nService.strings.awaitingScoreBadge,
          color: context.sealTertiary,
          icon: Icons.pending_outlined,
        ),
      ),
    );
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
          backgroundColor: context.sealPrimary.withValues(alpha: 0.14),
          child: Text(
            '#$rank',
            style: TextStyle(
              color: context.sealPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text(submission.projectName),
        subtitle: Text('$teamName\n${L10nService.strings.scoreCountLabel(scoreCount)}'),
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
              L10nService.strings.averageScoreAbbrev,
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
