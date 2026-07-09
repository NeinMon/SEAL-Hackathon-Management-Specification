import 'l10n/l10n_service.dart';
import '../models/app_notification.dart';
import '../models/team.dart';
import 'constants/app_routes.dart';
import 'helpers/app_roles.dart';
import 'route_query.dart';
import 'team_membership.dart';

class NotificationLink {
  const NotificationLink._();

  static final _eventPattern = RegExp(r'^\[\[event:([^\]]+)\]\]\s*');

  static String encodeEvent({
    required String eventId,
    required String content,
  }) {
    return '[[event:$eventId]] $content';
  }

  static String? eventId(String content) {
    final match = _eventPattern.firstMatch(content.trim());
    return match?.group(1);
  }

  static String displayContent(String content) {
    return content.trim().replaceFirst(_eventPattern, '').trim();
  }

  static String? actionLabelFor(
    AppNotification notification, {
    required String role,
  }) {
    final stored = notification.actionLabel?.trim();
    if (stored != null && stored.isNotEmpty) return stored;
    switch (notification.type) {
      case 'score':
        return role == AppRoles.participant
            ? L10nService.strings.notificationActionViewScore
            : L10nService.strings.notificationActionOpenJudge;
      case 'invitation':
        return L10nService.strings.notificationActionGoTeams;
      case 'announcement':
        return L10nService.strings.notificationActionViewEvent;
      case 'reminder':
        return L10nService.strings.journeyActionOpenMap;
      case 'system':
        if (role == AppRoles.participant) {
          return L10nService.strings.notificationActionSubmit;
        }
        if (role == AppRoles.judge) {
          return L10nService.strings.notificationActionOpenJudge;
        }
        return L10nService.strings.notificationActionViewEvent;
      default:
        return null;
    }
  }

  static String routeFor(
    AppNotification notification, {
    required String role,
    List<Team> teams = const [],
    String? userId,
  }) {
    final storedRoute = notification.deepRoute?.trim();
    if (storedRoute != null && storedRoute.isNotEmpty) return storedRoute;
    final linkedEventId = eventId(notification.content);
    switch (notification.type) {
      case 'score':
        if (role == AppRoles.participant &&
            userId != null &&
            linkedEventId != null) {
          final team = TeamMembership.teamForUserOnEvent(
            teams: teams,
            userId: userId,
            eventId: linkedEventId,
          );
          if (team != null) {
            return RouteQuery.submitForEvent(
              linkedEventId,
              teamId: team.id,
              view: RouteQuery.viewScore,
            );
          }
          return RouteQuery.teamsForEvent(linkedEventId);
        }
        if (linkedEventId != null && role == AppRoles.judge) {
          return RouteQuery.judgeForEvent(linkedEventId);
        }
        if (linkedEventId != null && role == AppRoles.organizer) {
          return RouteQuery.organizerForEvent(linkedEventId);
        }
        return role == AppRoles.participant
            ? AppRoutes.submit
            : AppRoutes.judge;
      case 'invitation':
        return linkedEventId == null
            ? AppRoutes.teams
            : RouteQuery.teamsForEvent(linkedEventId);
      case 'announcement':
        return linkedEventId == null
            ? AppRoutes.events
            : RouteQuery.overviewForEvent(linkedEventId);
      case 'reminder':
        return linkedEventId == null
            ? AppRoutes.map
            : RouteQuery.mapForEvent(linkedEventId);
      case 'system':
        if (role == AppRoles.participant) {
          if (linkedEventId != null && userId != null) {
            final team = TeamMembership.teamForUserOnEvent(
              teams: teams,
              userId: userId,
              eventId: linkedEventId,
            );
            if (team != null) {
              return RouteQuery.submitForEvent(linkedEventId, teamId: team.id);
            }
          }
          return linkedEventId == null
              ? AppRoutes.teams
              : RouteQuery.teamsForEvent(linkedEventId);
        }
        if (role == AppRoles.judge) return AppRoutes.judge;
        if (role == AppRoles.organizer) {
          return linkedEventId == null
              ? AppRoutes.organizer
              : RouteQuery.organizerForEvent(linkedEventId);
        }
        return AppRoutes.events;
      default:
        return AppRoutes.notifications;
    }
  }
}
