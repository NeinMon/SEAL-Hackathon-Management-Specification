import '../../../shared.dart';
import '../helpers/submission_view_data.dart';
import 'submission_draft_banner.dart';
import 'submission_history_card.dart';
import 'submission_hydration_listener.dart';
import 'submission_loading_view.dart';
import 'submission_status_card.dart';
import 'submission_submit_button.dart';
import 'submission_wizard_form.dart';

class SubmissionFormView extends StatelessWidget {
  const SubmissionFormView({
    super.key,
    required this.viewData,
    required this.formKey,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.error,
    required this.draftSavedAt,
    required this.hydratedSubmissionId,
    required this.formIsEmpty,
    required this.submissions,
    required this.scores,
    required this.onRefresh,
    required this.onTeamChanged,
    required this.onErrorChanged,
    required this.onSubmissionSaved,
    required this.onClearDraft,
    required this.onHydrateSubmission,
  });

  final SubmissionViewData viewData;
  final GlobalKey<FormState> formKey;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final String? error;
  final String? draftSavedAt;
  final String? hydratedSubmissionId;
  final bool formIsEmpty;
  final SubmissionProvider submissions;
  final ScoreProvider scores;
  final Future<void> Function() onRefresh;
  final ValueChanged<String?> onTeamChanged;
  final ValueChanged<String?> onErrorChanged;
  final VoidCallback onSubmissionSaved;
  final VoidCallback onClearDraft;
  final ValueChanged<ProjectSubmission> onHydrateSubmission;

  @override
  Widget build(BuildContext context) {
    final latest = viewData.latestSubmission;
    final targetTeam = viewData.targetTeam;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          SubmissionHydrationListener(
            latestSubmission: latest,
            hydratedSubmissionId: hydratedSubmissionId,
            shouldHydrate: formIsEmpty,
            onHydrate: onHydrateSubmission,
          ),
          const SubmissionScreenHeader(),
          SubmissionStatusCard(
            submission: latest,
            status: viewData.status,
            scoreCount: viewData.scoreCount,
            averageScore: viewData.scoreCount > 0 ? viewData.averageScore : null,
            highlightScore: viewData.scoreView && viewData.scoreCount > 0,
          ),
          if (viewData.scoreView && viewData.scoreCount > 0) ...[
            const SizedBox(height: 8),
            StatusBanner(
              message: L10nService.strings.submissionReadOnlyScoreTitle,
            ),
          ],
          const SizedBox(height: 14),
          if (viewData.hasDraft) ...[
            SubmissionDraftBanner(
              draftSavedAt: draftSavedAt,
              onClearDraft: onClearDraft,
            ),
            const SizedBox(height: 12),
          ],
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SubmissionWizardForm(
              formKey: formKey,
              projectName: projectName,
              github: github,
              video: video,
              description: description,
              myTeams: viewData.myTeams,
              targetTeam: targetTeam,
              targetEvent: viewData.targetEvent,
              latestSubmission: latest,
              loading: viewData.loading,
              submissionClosed: viewData.submissionClosed,
              submitActionLabel: viewData.submitActionLabel,
              readOnly: viewData.readOnly,
              onTeamChanged: onTeamChanged,
              onErrorChanged: onErrorChanged,
              onSubmissionSaved: onSubmissionSaved,
            ),
          ),
          const SizedBox(height: 12),
          StatusBanner(message: L10nService.strings.submissionDescriptionTip),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (submissions.error != null)
            StatusBanner(message: submissions.error!, isError: true),
          if (submissions.message != null)
            StatusBanner(message: submissions.message!),
          if (viewData.submissionBlockReason != null)
            StatusBanner(
              message: viewData.submissionBlockReason!,
              isError: true,
            ),
          if (!viewData.compact && !viewData.readOnly) ...[
            const SizedBox(height: AppSizes.paddingMedium),
            SubmissionSubmitButton(
              formKey: formKey,
              team: targetTeam,
              event: viewData.targetEvent,
              latestSubmission: latest,
              projectName: projectName,
              github: github,
              video: video,
              description: description,
              loading: viewData.loading,
              submissionClosed: viewData.submissionClosed,
              label: viewData.submitActionLabel,
              onErrorChanged: onErrorChanged,
              onSubmissionSaved: onSubmissionSaved,
            ),
          ],
          const SizedBox(height: 20),
          Text(
            L10nService.strings.latestSubmissionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (viewData.loading)
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
              submission: latest,
              history: submissions.historyFor(latest.id),
              scores: scores.scoresFor(latest.id),
            ),
        ],
      ),
    );
  }
}
