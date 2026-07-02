import '../models/hackathon_event.dart';
import '../models/project_submission.dart';
import '../models/team.dart';

class EventScope {
  const EventScope._();

  static List<Team> teamsForEvent(List<Team> teams, String eventId) =>
      teams.where((team) => team.eventId == eventId).toList();

  static Set<String> teamIdsForEvent(List<Team> teams, String eventId) =>
      teamsForEvent(teams, eventId).map((team) => team.id).toSet();

  static List<ProjectSubmission> submissionsForEvent({
    required List<ProjectSubmission> submissions,
    required List<Team> teams,
    required String eventId,
  }) {
    final teamIds = teamIdsForEvent(teams, eventId);
    return submissions
        .where((submission) => teamIds.contains(submission.teamId))
        .toList();
  }

  static String? eventTitleForSubmission({
    required ProjectSubmission submission,
    required List<Team> teams,
    required List<HackathonEvent> events,
  }) {
    for (final team in teams) {
      if (team.id != submission.teamId) continue;
      for (final event in events) {
        if (event.id == team.eventId) return event.title;
      }
    }
    return null;
  }
}
