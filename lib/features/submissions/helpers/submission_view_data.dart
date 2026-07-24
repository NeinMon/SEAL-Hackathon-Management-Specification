import '../../../shared.dart';
import '../widgets/submission_status_card.dart';

class SubmissionViewData {
  const SubmissionViewData({
    required this.loading,
    required this.myTeams,
    required this.targetTeam,
    required this.targetEvent,
    required this.latestSubmission,
    required this.submissionClosed,
    required this.submissionBlockReason,
    required this.submitActionLabel,
    required this.status,
    required this.scoreCount,
    required this.averageScore,
    required this.readOnly,
    required this.compact,
    required this.hasDraft,
    required this.scoreView,
  });

  final bool loading;
  final List<Team> myTeams;
  final Team? targetTeam;
  final HackathonEvent? targetEvent;
  final ProjectSubmission? latestSubmission;
  final bool submissionClosed;
  final String? submissionBlockReason;
  final String submitActionLabel;
  final SubmissionStatusInfo status;
  final int scoreCount;
  final double? averageScore;
  final bool readOnly;
  final bool compact;
  final bool hasDraft;
  final bool scoreView;

  static SubmissionViewData compute({
    required BuildContext context,
    required TeamProvider teams,
    required SubmissionProvider submissions,
    required ScoreProvider scores,
    required EventProvider events,
    required AppUser? user,
    required String? selectedTeamId,
    required String? draftTeamId,
    required bool formIsEmpty,
    required TextEditingController projectName,
    required TextEditingController github,
    required TextEditingController video,
    required TextEditingController description,
  }) {
    final loading = teams.isLoading || submissions.isLoading || scores.isLoading;
    final routeEventId = RouteQuery.eventIdFrom(context);
    final allMyTeams = user == null
        ? <Team>[]
        : teams.teams
              .where(
                (team) => team.members.any((member) => member.id == user.id),
              )
              .toList();
    final myTeams = routeEventId == null
        ? allMyTeams
        : allMyTeams
              .where((team) => team.eventId == routeEventId)
              .toList();
    final targetTeam = myTeams.isEmpty
        ? null
        : myTeams.firstWhere(
            (team) => team.id == selectedTeamId,
            orElse: () => myTeams.first,
          );
    final targetEvent = targetTeam == null
        ? null
        : events.byIdOrNull(targetTeam.eventId);
    final latestSubmission = targetTeam == null
        ? null
        : submissions.submissions
              .where((submission) => submission.teamId == targetTeam.id)
              .cast<ProjectSubmission?>()
              .fold<ProjectSubmission?>(
                null,
                (previous, current) =>
                    previous == null ||
                        current!.submittedAt.isAfter(previous.submittedAt)
                    ? current
                    : previous,
              );
    final submissionClosed =
        targetEvent != null && !targetEvent.submissionOpen();
    final submitActionLabel = latestSubmission == null
        ? L10nService.strings.submitProjectAction
        : L10nService.strings.updateSubmissionButton;
    final status = resolveSubmissionStatus(context, latestSubmission, scores);
    final scoreCount = latestSubmission == null
        ? 0
        : scores.scoreCountFor(latestSubmission.id);
    final averageScore = latestSubmission == null
        ? null
        : scores.averageFor(latestSubmission.id);
    final scoreView = RouteQuery.isScoreView(context);
    final readOnly = isReadOnly(
      scoreView: scoreView,
      scoreCount: scoreCount,
      hasSubmission: latestSubmission != null,
      submissionClosed: submissionClosed,
    );
    final compact = MediaQuery.sizeOf(context).width < 760;
    final hasDraft =
        draftTeamId == targetTeam?.id &&
        latestSubmission == null &&
        !formIsEmpty;

    return SubmissionViewData(
      loading: loading,
      myTeams: myTeams,
      targetTeam: targetTeam,
      targetEvent: targetEvent,
      latestSubmission: latestSubmission,
      submissionClosed: submissionClosed,
      submissionBlockReason: targetEvent?.submissionBlockReason(),
      submitActionLabel: submitActionLabel,
      status: status,
      scoreCount: scoreCount,
      averageScore: averageScore,
      readOnly: readOnly,
      compact: compact,
      hasDraft: hasDraft,
      scoreView: scoreView,
    );
  }

  static bool isReadOnly({
    required bool scoreView,
    required int scoreCount,
    required bool hasSubmission,
    required bool submissionClosed,
  }) {
    if (scoreView) return true;
    if (scoreCount > 0) return true;
    if (hasSubmission && submissionClosed) return true;
    return false;
  }

  static bool formIsEmpty({
    required TextEditingController projectName,
    required TextEditingController github,
    required TextEditingController video,
    required TextEditingController description,
  }) {
    return projectName.text.trim().isEmpty &&
        github.text.trim().isEmpty &&
        video.text.trim().isEmpty &&
        description.text.trim().isEmpty;
  }
}
