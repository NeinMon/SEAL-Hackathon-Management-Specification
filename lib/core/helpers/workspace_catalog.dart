import '../../models/hackathon_event.dart';
import '../../models/team.dart';

/// In-memory snapshot of events and teams for lifecycle checks when UI
/// does not pass a resolved [HackathonEvent].
class WorkspaceCatalog {
  const WorkspaceCatalog._();

  static List<HackathonEvent> events = const [];
  static List<Team> teams = const [];

  static void bind({
    required List<HackathonEvent> events,
    required List<Team> teams,
  }) {
    WorkspaceCatalog.events = events;
    WorkspaceCatalog.teams = teams;
  }

  static HackathonEvent? eventById(String? eventId) {
    if (eventId == null || eventId.isEmpty) return null;
    for (final event in events) {
      if (event.id == eventId) return event;
    }
    return null;
  }

  static Team? teamById(String? teamId) {
    if (teamId == null || teamId.isEmpty) return null;
    for (final team in teams) {
      if (team.id == teamId) return team;
    }
    return null;
  }

  static HackathonEvent? eventForTeam(Team? team) =>
      team == null ? null : eventById(team.eventId);

  static HackathonEvent? eventForTeamId(String? teamId) =>
      eventForTeam(teamById(teamId));
}
