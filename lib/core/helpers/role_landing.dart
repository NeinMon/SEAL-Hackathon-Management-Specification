import '../../models/hackathon_event.dart';
import '../../models/team.dart';
import '../constants/app_routes.dart';
import '../route_query.dart';
import '../team_membership.dart';
import 'active_event_resolver.dart';
import 'app_roles.dart';

class RoleLanding {
  const RoleLanding._();

  static String initialRouteForRole(String role) {
    switch (role) {
      case AppRoles.organizer:
        return AppRoutes.organizer;
      case AppRoles.judge:
      case AppRoles.mentor:
      case AppRoles.participant:
      default:
        return AppRoutes.events;
    }
  }

  /// After events/teams load, deep-link into the active event workspace when possible.
  static String? deepLinkAfterBootstrap({
    required String role,
    required List<HackathonEvent> events,
    required List<Team> teams,
    required String userId,
    String? storedEventId,
  }) {
    if (events.isEmpty) return null;
    final eventId = ActiveEventResolver.resolveId(
      events: events,
      storedEventId: storedEventId,
      userId: userId,
      teams: teams,
    );
    if (eventId == null) return null;

    switch (role) {
      case AppRoles.participant:
        final team = TeamMembership.teamForUserOnEvent(
          teams: teams,
          userId: userId,
          eventId: eventId,
        );
        if (team == null) return null;
        return RouteQuery.overviewForEvent(eventId);
      case AppRoles.mentor:
        return RouteQuery.chatForEvent(eventId);
      case AppRoles.judge:
        HackathonEvent? event;
        for (final candidate in events) {
          if (candidate.id == eventId) {
            event = candidate;
            break;
          }
        }
        if (event != null && event.judgingOpen()) {
          return RouteQuery.judgeForEvent(eventId);
        }
        return RouteQuery.overviewForEvent(eventId);
      default:
        return null;
    }
  }
}
