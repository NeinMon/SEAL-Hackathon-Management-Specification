import '../../../shared.dart';
import '../widgets/submission_history_card.dart';

class SubmissionHistoryScreen extends StatelessWidget {
  const SubmissionHistoryScreen({
    super.key,
    required this.latest,
    required this.targetTeam,
    required this.submissions,
    required this.scores,
    required this.loading,
    required this.onRefresh,
  });

  final ProjectSubmission? latest;
  final Team? targetTeam;
  final SubmissionProvider submissions;
  final ScoreProvider scores;
  final bool loading;
  final Future<void> Function() onRefresh;

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingCompact),
        children: [
          if (loading)
            const LoadingCardList(itemCount: 1)
          else if (targetTeam == null)
            EmptyState(
              message: L10nService.strings.selectTeamToSubmit,
              actionLabel: L10nService.strings.createTeamNowAction,
              onAction: () {
                final eventId =
                    context.read<ActiveEventProvider>().selectedEventId;
                context.go(
                  eventId == null
                      ? AppRoutes.teams
                      : RouteQuery.teamsForEvent(eventId),
                );
              },
            )
          else if (latest == null)
            EmptyState(message: context.l10n.teamHasNoSubmission)
          else
            SubmissionHistoryCard(
              submission: latest!,
              history: submissions.historyFor(latest!.id),
              scores: scores.scoresFor(latest!.id),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppSizes.shellHeaderHeight,
        title: Text(L10nService.strings.latestSubmissionTitle),
      ),
      body: _body(context),
    );
  }
}
