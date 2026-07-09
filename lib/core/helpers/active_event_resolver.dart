import '../../models/hackathon_event.dart';
import '../../models/team.dart';
import '../team_membership.dart';

class ActiveEventResolver {
  const ActiveEventResolver._();

  static String? resolveId({
    required List<HackathonEvent> events,
    String? routeEventId,
    String? storedEventId,
    String? userId,
    List<Team> teams = const [],
  }) {
    if (events.isEmpty) return null;

    if (routeEventId != null && _hasEvent(events, routeEventId)) {
      return routeEventId;
    }
    if (storedEventId != null && _hasEvent(events, storedEventId)) {
      return storedEventId;
    }
    if (userId != null) {
      for (final event in events) {
        final team = TeamMembership.teamForUserOnEvent(
          teams: teams,
          userId: userId,
          eventId: event.id,
        );
        if (team != null) return event.id;
      }
    }
    return null;
  }

  static HackathonEvent? resolveEvent({
    required List<HackathonEvent> events,
    String? routeEventId,
    String? storedEventId,
    String? userId,
    List<Team> teams = const [],
  }) {
    final id = resolveId(
      events: events,
      routeEventId: routeEventId,
      storedEventId: storedEventId,
      userId: userId,
      teams: teams,
    );
    if (id == null) return null;
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  static bool _hasEvent(List<HackathonEvent> events, String eventId) {
    return events.any((event) => event.id == eventId);
  }
}
