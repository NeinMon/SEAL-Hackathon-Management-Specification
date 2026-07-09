import '../../../shared.dart';
import '../helpers/judge_queue_view_data.dart';
import 'judge_submission_card.dart';
import 'judge_submission_selector.dart';

class JudgeQueueWorkspace extends StatelessWidget {
  const JudgeQueueWorkspace({
    super.key,
    required this.viewData,
    required this.eventId,
    required this.scores,
    required this.teams,
    required this.events,
    required this.judge,
    required this.selectedSubmissionId,
    required this.onSubmissionSelected,
    required this.onNextUnscored,
    required this.onShowAllSubmissions,
  });

  final JudgeQueueViewData viewData;
  final String? eventId;
  final ScoreProvider scores;
  final List<Team> teams;
  final List<HackathonEvent> events;
  final AppUser? judge;
  final String? selectedSubmissionId;
  final ValueChanged<String?> onSubmissionSelected;
  final VoidCallback onNextUnscored;
  final VoidCallback onShowAllSubmissions;

  @override
  Widget build(BuildContext context) {
    if (viewData.loading) {
      return const LoadingCardList(itemCount: 3);
    }
    if (viewData.submissions.isEmpty) {
      return EmptyState(
        message: L10nService.strings.noMatchingSubmissions,
        actionLabel: L10nService.strings.showAllSubmissions,
        onAction: onShowAllSubmissions,
      );
    }

    final selected = viewData.selectedSubmission;
    return AdaptiveTwoPane(
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JudgeSubmissionSelector(
            submissions: viewData.submissions,
            scores: scores,
            teams: teams,
            events: events,
            value: selected?.id,
            showEventContext: eventId == null,
            onChanged: onSubmissionSelected,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: viewData.unscored == 0 ? null : onNextUnscored,
            icon: const Icon(Icons.skip_next_outlined),
            label: Text(context.l10n.nextUnscoredButton),
          ),
        ],
      ),
      trailing: selected == null
          ? EmptyState(message: context.l10n.selectSubmissionToScore)
          : JudgeSubmissionCard(
              key: ValueKey('judge-card-${selected.id}'),
              submission: selected,
              event: viewData.selectedEvent,
              events: events,
              scores: scores,
              teams: teams,
              judge: judge,
              canSubmit: viewData.isJudge && !scores.isLoading,
            ),
    );
  }
}

class JudgeNextUnscoredBar extends StatelessWidget {
  const JudgeNextUnscoredBar({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSizes.paddingMedium,
      right: AppSizes.paddingMedium,
      bottom: AppSizes.paddingMedium,
      child: SafeArea(
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FilledButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: const Icon(Icons.skip_next_outlined),
              label: Text(context.l10n.nextUnscoredButton),
            ),
          ),
        ),
      ),
    );
  }
}
