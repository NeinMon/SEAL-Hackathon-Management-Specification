import '../../../shared.dart';
import '../helpers/submission_view_data.dart';
import 'submission_form_view.dart';
import 'submission_loading_view.dart';

class SubmissionContent extends StatelessWidget {
  const SubmissionContent({
    super.key,
    required this.formKey,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.error,
    required this.selectedTeamId,
    required this.onErrorChanged,
    required this.hydratedSubmissionId,
    this.draftTeamId,
    this.draftSavedAt,
    required this.onTeamChanged,
    required this.onHydrateSubmission,
    required this.onSubmissionSaved,
    required this.onClearDraft,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final String? error;
  final String? selectedTeamId;
  final ValueChanged<String?> onErrorChanged;
  final String? hydratedSubmissionId;
  final String? draftTeamId;
  final String? draftSavedAt;
  final ValueChanged<String?> onTeamChanged;
  final ValueChanged<ProjectSubmission> onHydrateSubmission;
  final VoidCallback onSubmissionSaved;
  final VoidCallback onClearDraft;

  Future<void> _refreshAll(BuildContext context, Team? targetTeam) async {
    final eventId = targetTeam?.eventId;
    await Future.wait([
      context.read<TeamProvider>().loadTeams(eventId: eventId),
      context.read<SubmissionProvider>().loadSubmissions(eventId: eventId),
      context.read<ScoreProvider>().loadScores(eventId: eventId),
      context.read<EventProvider>().loadEvents(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<TeamProvider>();
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final events = context.watch<EventProvider>();
    final user = context.watch<AuthProvider>().user;
    final formIsEmpty = SubmissionViewData.formIsEmpty(
      projectName: projectName,
      github: github,
      video: video,
      description: description,
    );
    final viewData = SubmissionViewData.compute(
      context: context,
      teams: teams,
      submissions: submissions,
      scores: scores,
      events: events,
      user: user,
      selectedTeamId: selectedTeamId,
      draftTeamId: draftTeamId,
      formIsEmpty: formIsEmpty,
      projectName: projectName,
      github: github,
      video: video,
      description: description,
    );

    if (viewData.loading) {
      return SubmissionLoadingView(
        onRefresh: () => _refreshAll(context, viewData.targetTeam),
      );
    }

    if (viewData.myTeams.isEmpty) {
      return SubmissionEmptyTeamsView(
        onRefresh: () => _refreshAll(context, null),
      );
    }

    return SubmissionFormView(
      viewData: viewData,
      formKey: formKey,
      projectName: projectName,
      github: github,
      video: video,
      description: description,
      error: error,
      draftSavedAt: draftSavedAt,
      hydratedSubmissionId: hydratedSubmissionId,
      formIsEmpty: formIsEmpty,
      submissions: submissions,
      scores: scores,
      onRefresh: () => _refreshAll(context, viewData.targetTeam),
      onTeamChanged: onTeamChanged,
      onErrorChanged: onErrorChanged,
      onSubmissionSaved: onSubmissionSaved,
      onClearDraft: onClearDraft,
      onHydrateSubmission: onHydrateSubmission,
    );
  }
}
