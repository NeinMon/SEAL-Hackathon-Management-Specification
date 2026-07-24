import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';
import '../widgets/judge_progress.dart';
import '../widgets/judge_queue_list.dart';
import '../widgets/judge_queue_toolbar.dart';

class JudgeQueueScreen extends StatelessWidget {
  const JudgeQueueScreen({
    super.key,
    required this.viewData,
    required this.eventId,
    required this.filter,
    required this.sort,
    required this.search,
    required this.submissionProvider,
    required this.scores,
    required this.teams,
    required this.events,
    required this.onRefresh,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onSubmissionTap,
    required this.onShowUnscored,
  });

  final JudgeQueueViewData viewData;
  final String? eventId;
  final String filter;
  final String sort;
  final TextEditingController search;
  final SubmissionProvider submissionProvider;
  final ScoreProvider scores;
  final List<Team> teams;
  final List<HackathonEvent> events;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<ProjectSubmission> onSubmissionTap;
  final VoidCallback onShowUnscored;

  static String? _queueStatusMessage(
    ScoreProvider scores,
    SubmissionProvider submissions,
  ) {
    return [
      ?scores.error,
      ?submissions.error,
      ?scores.message,
    ].join('\n').trim().isEmpty
        ? null
        : [
            ?scores.error,
            ?submissions.error,
            ?scores.message,
          ].join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingCompact,
            AppSizes.paddingCompact,
            AppSizes.paddingCompact,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SealSectionHeader(
                title: viewData.filteredEvent == null
                    ? L10nService.strings.judgeTitle
                    : L10nService.strings.judgeQueueForEventTitle(
                        viewData.filteredEvent!.title,
                      ),
                subtitle: viewData.filteredEvent == null
                    ? L10nService.strings.judgeSubtitle
                    : null,
                icon: Icons.rate_review_outlined,
                trailing: IconButton.filledTonal(
                  tooltip: context.l10n.reloadJudgeQueueTooltip,
                  onPressed: viewData.loading ? null : onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ),
              if (!viewData.isJudge)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      child: Text(context.l10n.judgePreviewOnlyMessage),
                    ),
                  ),
                ),
              if (_queueStatusMessage(
                    scores,
                    submissionProvider,
                  ) case final message?)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StatusBanner(
                    message: message,
                    isError: scores.error != null ||
                        submissionProvider.error != null,
                  ),
                ),
              JudgeProgressInline(
                total: viewData.total,
                scored: viewData.scored,
                unscored: viewData.unscored,
              ),
              const SizedBox(height: 12),
              JudgeQueueToolbar(
                filter: filter,
                sort: sort,
                search: search,
                unscoredCount: viewData.unscored,
                scoredCount: viewData.scored,
                onFilterChanged: onFilterChanged,
                onSortChanged: onSortChanged,
              ),
              if (search.text.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InputChip(
                    label: Text(search.text.trim()),
                    onDeleted: search.clear,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _queueBody(context)),
      ],
    );
  }

  Widget _queueBody(BuildContext context) {
    if (viewData.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
        child: LoadingCardList(itemCount: 4),
      );
    }
    if (viewData.submissions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: EmptyState(
          message: L10nService.strings.noMatchingSubmissions,
          actionLabel: filter == 'unscored'
              ? L10nService.strings.filterScored
              : L10nService.strings.filterUnscored,
          onAction: onShowUnscored,
        ),
      );
    }
    return JudgeQueueList(
      submissions: viewData.submissions,
      scores: scores,
      teams: teams,
      events: events,
      showEventContext: eventId == null,
      onSubmissionTap: onSubmissionTap,
    );
  }
}
