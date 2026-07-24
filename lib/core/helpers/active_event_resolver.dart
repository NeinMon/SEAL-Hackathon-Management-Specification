import '../../models/hackathon_event.dart';
import '../../models/team.dart';
import '../helpers/event_sort.dart';
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
    return preferDefaultEventId(events);
  }

  /// Picks a sensible default when route, stored preference, and team
  /// membership do not resolve an event: open registration first, then any
  /// event that has not ended, then the first event in the list.
  static String? preferDefaultEventId(List<HackathonEvent> events) {
    final event = preferDefaultEvent(events);
    return event?.id;
  }

  static HackathonEvent? preferDefaultEvent(List<HackathonEvent> events) {
    if (events.isEmpty) return null;
    final sorted = EventSort.sorted(events);
    for (final event in sorted) {
      if (event.registrationOpen()) return event;
    }
    final now = DateTime.now();
    for (final event in sorted) {
      if (!event.endDate.isBefore(now)) return event;
    }
    return sorted.first;
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
