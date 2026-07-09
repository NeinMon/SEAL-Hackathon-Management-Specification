import '../../../shared.dart';

class OrganizerDashboardMetrics {
  const OrganizerDashboardMetrics({
    required this.focusEvent,
    required this.focusEventId,
    required this.scopedTeams,
    required this.scopedSubmissions,
    required this.scopedEvents,
    required this.unscored,
    required this.teamsNeedingMembers,
    required this.eventsClosingSoon,
    required this.notificationSuggestions,
    required this.reminderEventId,
    required this.reminderEventTitle,
    required this.overviewActiveEvents,
    required this.loading,
  });

  final HackathonEvent? focusEvent;
  final String? focusEventId;
  final List<Team> scopedTeams;
  final List<ProjectSubmission> scopedSubmissions;
  final List<HackathonEvent> scopedEvents;
  final int unscored;
  final int teamsNeedingMembers;
  final int eventsClosingSoon;
  final int notificationSuggestions;
  final String? reminderEventId;
  final String reminderEventTitle;
  final int overviewActiveEvents;
  final bool loading;

  static OrganizerDashboardMetrics compute({
    required EventProvider events,
    required TeamProvider teams,
    required SubmissionProvider submissions,
    required ScoreProvider scores,
    required String? focusEventId,
  }) {
    HackathonEvent? focusEvent;
    if (focusEventId != null) {
      focusEvent = events.byIdOrNull(focusEventId);
    }
    final scopedTeams = focusEventId == null
        ? teams.teams
        : EventScope.teamsForEvent(teams.teams, focusEventId);
    final scopedSubmissions = focusEventId == null
        ? submissions.submissions
        : EventScope.submissionsForEvent(
            submissions: submissions.submissions,
            teams: teams.teams,
            eventId: focusEventId,
          );
    final scopedEvents = focusEvent == null ? events.events : [focusEvent];
    final unscored = scopedSubmissions
        .where((submission) => scores.scoreCountFor(submission.id) == 0)
        .length;
    final teamsNeedingMembers = scopedTeams.where((team) {
      final event = events.byIdOrNull(team.eventId);
      if (event == null || event.maxTeamSize <= 0) return false;
      return team.members.length < event.maxTeamSize;
    }).length;
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 3));
    final eventsClosingSoon = scopedEvents.where((event) {
      return event.registrationDeadline.isAfter(now) &&
          event.registrationDeadline.isBefore(soon);
    }).length;
    final notificationSuggestions =
        (unscored > 0 ? 1 : 0) +
        (teamsNeedingMembers > 0 ? 1 : 0) +
        (eventsClosingSoon > 0 ? 1 : 0);
    final reminderEventId =
        focusEventId ?? (scopedEvents.isNotEmpty ? scopedEvents.first.id : null);
    final reminderEventTitle = focusEvent?.title ??
        (scopedEvents.isNotEmpty ? scopedEvents.first.title : '');
    final activeEvents = events.events.where((event) {
      final current = DateTime.now();
      return event.startDate.isBefore(current) && event.endDate.isAfter(current);
    }).length;
    final overviewActiveEvents = focusEvent == null
        ? activeEvents
        : (focusEvent.startDate.isBefore(DateTime.now()) &&
                  focusEvent.endDate.isAfter(DateTime.now())
              ? 1
              : 0);
    final loading =
        events.isLoading ||
        teams.isLoading ||
        submissions.isLoading ||
        scores.isLoading;

    return OrganizerDashboardMetrics(
      focusEvent: focusEvent,
      focusEventId: focusEventId,
      scopedTeams: scopedTeams,
      scopedSubmissions: scopedSubmissions,
      scopedEvents: scopedEvents,
      unscored: unscored,
      teamsNeedingMembers: teamsNeedingMembers,
      eventsClosingSoon: eventsClosingSoon,
      notificationSuggestions: notificationSuggestions,
      reminderEventId: reminderEventId,
      reminderEventTitle: reminderEventTitle,
      overviewActiveEvents: overviewActiveEvents,
      loading: loading,
    );
  }
}
