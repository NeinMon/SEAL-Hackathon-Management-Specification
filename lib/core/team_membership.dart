import '../models/team.dart';

class TeamMembership {
  const TeamMembership._();

  static Team? teamForUserOnEvent({
    required List<Team> teams,
    required String userId,
    required String eventId,
    String? excludeTeamId,
  }) {
    for (final team in teams) {
      if (team.eventId != eventId) continue;
      if (excludeTeamId != null && team.id == excludeTeamId) continue;
      if (team.members.any((member) => member.id == userId)) {
        return team;
      }
    }
    return null;
  }

  static bool hasTeamOnEvent({
    required List<Team> teams,
    required String userId,
    required String eventId,
    String? excludeTeamId,
  }) {
    return teamForUserOnEvent(
          teams: teams,
          userId: userId,
          eventId: eventId,
          excludeTeamId: excludeTeamId,
        ) !=
        null;
  }
}
