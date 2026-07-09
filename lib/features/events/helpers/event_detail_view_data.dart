import '../../../shared.dart';

class EventDetailViewData {
  const EventDetailViewData({
    required this.eventTeams,
    required this.eventSubmissions,
    required this.scoredSubmissions,
    required this.pendingSubmissions,
    required this.myTeam,
    required this.journey,
    required this.unscoredCount,
  });

  final List<Team> eventTeams;
  final List<ProjectSubmission> eventSubmissions;
  final List<ProjectSubmission> scoredSubmissions;
  final List<ProjectSubmission> pendingSubmissions;
  final Team? myTeam;
  final ParticipantJourney? journey;
  final int unscoredCount;

  static EventDetailViewData compute({
    required HackathonEvent event,
    required List<Team> teams,
    required List<ProjectSubmission> submissions,
    required ScoreProvider scores,
    required AppUser? user,
  }) {
    final eventTeams =
        teams.where((team) => team.eventId == event.id).toList();
    final eventTeamIds = eventTeams.map((team) => team.id).toSet();
    final myTeam = user == null
        ? null
        : TeamMembership.teamForUserOnEvent(
            teams: teams,
            userId: user.id,
            eventId: event.id,
          );
    final eventSubmissions = submissions
        .where((submission) => eventTeamIds.contains(submission.teamId))
        .toList();
    final scoredSubmissions =
        eventSubmissions
            .where((submission) => scores.scoreCountFor(submission.id) > 0)
            .toList()
          ..sort(
            (a, b) =>
                scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
          );
    final pendingSubmissions =
        eventSubmissions
            .where((submission) => scores.scoreCountFor(submission.id) == 0)
            .toList()
          ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    final journey = user == null
        ? null
        : ParticipantJourney.forUser(
            event: event,
            userId: user.id,
            teams: teams,
            submissions: submissions,
            scores: scores,
          );

    return EventDetailViewData(
      eventTeams: eventTeams,
      eventSubmissions: eventSubmissions,
      scoredSubmissions: scoredSubmissions,
      pendingSubmissions: pendingSubmissions,
      myTeam: myTeam,
      journey: journey,
      unscoredCount: pendingSubmissions.length,
    );
  }
}
