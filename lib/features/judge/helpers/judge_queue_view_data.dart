import '../../../shared.dart';

class JudgeQueueViewData {
  const JudgeQueueViewData({
    required this.queueSource,
    required this.submissions,
    required this.total,
    required this.scored,
    required this.unscored,
    required this.selectedSubmission,
    required this.selectedEvent,
    required this.filteredEvent,
    required this.loading,
    required this.isJudge,
  });

  final List<ProjectSubmission> queueSource;
  final List<ProjectSubmission> submissions;
  final int total;
  final int scored;
  final int unscored;
  final ProjectSubmission? selectedSubmission;
  final HackathonEvent? selectedEvent;
  final HackathonEvent? filteredEvent;
  final bool loading;
  final bool isJudge;

  static JudgeQueueViewData compute({
    required AuthProvider auth,
    required SubmissionProvider submissionProvider,
    required ScoreProvider scores,
    required TeamProvider teamsProvider,
    required EventProvider events,
    required String? eventId,
    required String filter,
    required String sort,
    required TextEditingController search,
    required String? selectedSubmissionId,
  }) {
    final teams = teamsProvider.teams;
    final filteredEvent =
        eventId == null ? null : events.byIdOrNull(eventId);
    final queueSource = submissionsForEvent(
      submissionProvider.submissions,
      teams,
      eventId,
    );
    final visible = visibleSubmissions(
      all: queueSource,
      scores: scores,
      teams: teams,
      filter: filter,
      sort: sort,
      search: search,
    );
    final total = queueSource.length;
    final scoredCount = queueSource
        .where((submission) => scores.scoreCountFor(submission.id) > 0)
        .length;
    final loading =
        submissionProvider.isLoading ||
        scores.isLoading ||
        teamsProvider.isLoading;
    final selected = resolveSelectedSubmission(
      visible,
      scores,
      selectedSubmissionId,
    );

    return JudgeQueueViewData(
      queueSource: queueSource,
      submissions: visible,
      total: total,
      scored: scoredCount,
      unscored: total - scoredCount,
      selectedSubmission: selected,
      selectedEvent: selected == null
          ? null
          : eventForSubmission(selected, teams, events),
      filteredEvent: filteredEvent,
      loading: loading,
      isJudge: auth.user?.role == 'judge',
    );
  }

  static List<ProjectSubmission> submissionsForEvent(
    List<ProjectSubmission> all,
    List<Team> teams,
    String? eventId,
  ) {
    if (eventId == null) return all;
    return all
        .where((submission) => submissionEventId(submission, teams) == eventId)
        .toList();
  }

  static String? submissionEventId(
    ProjectSubmission submission,
    List<Team> teams,
  ) {
    for (final team in teams) {
      if (team.id == submission.teamId) return team.eventId;
    }
    return null;
  }

  static List<ProjectSubmission> visibleSubmissions({
    required List<ProjectSubmission> all,
    required ScoreProvider scores,
    required List<Team> teams,
    required String filter,
    required String sort,
    required TextEditingController search,
  }) {
    final filtered = all.where((submission) {
      final scored = scores.scoreCountFor(submission.id) > 0;
      final keyword = search.text.trim().toLowerCase();
      final teamName = teamNameFor(submission.teamId, teams).toLowerCase();
      final matchesSearch =
          keyword.isEmpty ||
          submission.projectName.toLowerCase().contains(keyword) ||
          submission.description.toLowerCase().contains(keyword) ||
          teamName.contains(keyword);
      final matchesFilter =
          filter == 'all' ||
          (filter == 'scored' && scored) ||
          (filter == 'unscored' && !scored);
      return matchesSearch && matchesFilter;
    }).toList();
    switch (sort) {
      case 'project':
        filtered.sort((a, b) => a.projectName.compareTo(b.projectName));
      case 'team':
        filtered.sort(
          (a, b) => teamNameFor(a.teamId, teams).compareTo(
            teamNameFor(b.teamId, teams),
          ),
        );
      case 'score':
        filtered.sort(
          (a, b) => scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
        );
      default:
        filtered.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    }
    return filtered;
  }

  static ProjectSubmission? resolveSelectedSubmission(
    List<ProjectSubmission> submissions,
    ScoreProvider scores,
    String? selectedSubmissionId,
  ) {
    if (submissions.isEmpty) return null;
    if (selectedSubmissionId != null) {
      for (final submission in submissions) {
        if (submission.id == selectedSubmissionId) return submission;
      }
    }
    for (final submission in submissions) {
      if (scores.scoreCountFor(submission.id) == 0) return submission;
    }
    return submissions.first;
  }

  static String teamNameFor(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return L10nService.strings.unknownTeamLabel;
  }

  static HackathonEvent? eventForSubmission(
    ProjectSubmission submission,
    List<Team> teams,
    EventProvider events,
  ) {
    for (final team in teams) {
      if (team.id == submission.teamId) {
        return events.byIdOrNull(team.eventId);
      }
    }
    return null;
  }

  static String? nextUnscoredId({
    required List<ProjectSubmission> queueSource,
    required ScoreProvider scores,
    required List<Team> teams,
    required String sort,
    required TextEditingController search,
  }) {
    final queue = visibleSubmissions(
      all: queueSource,
      scores: scores,
      teams: teams,
      filter: 'all',
      sort: sort,
      search: search,
    );
    for (final submission in queue) {
      if (scores.scoreCountFor(submission.id) == 0) return submission.id;
    }
    return null;
  }
}
