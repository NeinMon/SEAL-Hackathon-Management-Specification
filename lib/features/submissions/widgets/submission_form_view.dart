import '../../../shared.dart';
import '../helpers/submission_view_data.dart';
import '../screens/submission_history_screen.dart';
import 'submission_draft_banner.dart';
import 'submission_hydration_listener.dart';
import 'submission_status_card.dart';
import 'submission_submit_button.dart';
import 'submission_wizard_form.dart';

class SubmissionFormView extends StatefulWidget {
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
  State<SubmissionFormView> createState() => _SubmissionFormViewState();
}

class _SubmissionFormViewState extends State<SubmissionFormView> {
  void _openHistory() {
    final latest = widget.viewData.latestSubmission;
    final targetTeam = widget.viewData.targetTeam;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => SubmissionHistoryScreen(
          latest: latest,
          targetTeam: targetTeam,
          submissions: widget.submissions,
          scores: widget.scores,
          loading: widget.viewData.loading,
          onRefresh: widget.onRefresh,
        ),
      ),
    );
  }

  List<Widget> _errorBanners() {
    final banners = <Widget>[];
    if (widget.error != null) {
      banners.add(
        Text(
          widget.error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }
    if (widget.submissions.error != null) {
      banners.add(StatusBanner(message: widget.submissions.error!, isError: true));
    }
    if (widget.submissions.message != null) {
      banners.add(StatusBanner(message: widget.submissions.message!));
    }
    if (widget.viewData.submissionBlockReason != null) {
      banners.add(
        StatusBanner(
          message: widget.viewData.submissionBlockReason!,
          isError: true,
        ),
      );
    }
    return banners;
  }

  Widget _buildStickyFooter() {
    final viewData = widget.viewData;
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingMedium,
            10,
            AppSizes.paddingMedium,
            AppSizes.paddingMedium,
          ),
          child: SubmissionSubmitButton(
            formKey: widget.formKey,
            team: viewData.targetTeam,
            event: viewData.targetEvent,
            latestSubmission: viewData.latestSubmission,
            projectName: widget.projectName,
            github: widget.github,
            video: widget.video,
            description: widget.description,
            loading: viewData.loading,
            submissionClosed: viewData.submissionClosed,
            label: viewData.submitActionLabel,
            onErrorChanged: widget.onErrorChanged,
            onSubmissionSaved: widget.onSubmissionSaved,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewData = widget.viewData;
    final latest = viewData.latestSubmission;
    final targetTeam = viewData.targetTeam;
    final compact = viewData.compact;
    final showStickySubmit = compact && !viewData.readOnly;
    final bottomPadding = showStickySubmit ? 96.0 : AppSizes.paddingMedium;

    final children = <Widget>[
      SubmissionHydrationListener(
        latestSubmission: latest,
        hydratedSubmissionId: widget.hydratedSubmissionId,
        shouldHydrate: widget.formIsEmpty,
        onHydrate: widget.onHydrateSubmission,
      ),
      SealSectionHeader(
        title: L10nService.strings.submitScreenTitle,
        subtitle: L10nService.strings.submitScreenSubtitle,
        icon: Icons.upload_file_outlined,
        trailing: IconButton.filledTonal(
          tooltip: L10nService.strings.latestSubmissionTitle,
          onPressed: _openHistory,
          icon: const Icon(Icons.history_outlined),
        ),
      ),
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
          draftSavedAt: widget.draftSavedAt,
          onClearDraft: widget.onClearDraft,
        ),
        const SizedBox(height: 12),
      ],
      if (_errorBanners().isNotEmpty) ...[
        ..._errorBanners(),
        const SizedBox(height: 12),
      ],
      Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SubmissionWizardForm(
          formKey: widget.formKey,
          projectName: widget.projectName,
          github: widget.github,
          video: widget.video,
          description: widget.description,
          myTeams: viewData.myTeams,
          targetTeam: targetTeam,
          targetEvent: viewData.targetEvent,
          latestSubmission: latest,
          loading: viewData.loading,
          submissionClosed: viewData.submissionClosed,
          submitActionLabel: viewData.submitActionLabel,
          readOnly: viewData.readOnly,
          onTeamChanged: widget.onTeamChanged,
          onErrorChanged: widget.onErrorChanged,
          onSubmissionSaved: widget.onSubmissionSaved,
        ),
      ),
      if (!compact && !viewData.readOnly) ...[
        const SizedBox(height: AppSizes.paddingMedium),
        SubmissionSubmitButton(
          formKey: widget.formKey,
          team: targetTeam,
          event: viewData.targetEvent,
          latestSubmission: latest,
          projectName: widget.projectName,
          github: widget.github,
          video: widget.video,
          description: widget.description,
          loading: viewData.loading,
          submissionClosed: viewData.submissionClosed,
          label: viewData.submitActionLabel,
          onErrorChanged: widget.onErrorChanged,
          onSubmissionSaved: widget.onSubmissionSaved,
        ),
      ],
    ];

    final scrollView = RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSizes.paddingMedium,
          AppSizes.paddingMedium,
          AppSizes.paddingMedium,
          bottomPadding,
        ),
        children: children,
      ),
    );

    if (!showStickySubmit) return scrollView;

    return Column(
      children: [
        Expanded(child: scrollView),
        _buildStickyFooter(),
      ],
    );
  }
}
