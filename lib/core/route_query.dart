import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_routes.dart';

class RouteQuery {
  const RouteQuery._();

  static const eventKey = 'event';
  static const teamKey = 'team';

  static String teamsForEvent(String eventId) =>
      '${AppRoutes.teams}?$eventKey=$eventId';

  static String judgeForEvent(String eventId) =>
      '${AppRoutes.judge}?$eventKey=$eventId';

  static String submitForTeam(String teamId) =>
      '${AppRoutes.submit}?$teamKey=$teamId';

  static String mapForEvent(String eventId) =>
      '${AppRoutes.map}?$eventKey=$eventId';

  static String organizerForEvent(String eventId) =>
      '${AppRoutes.organizer}?$eventKey=$eventId';

  static String? eventIdFrom(BuildContext context) =>
      GoRouter.maybeOf(context)?.state.uri.queryParameters[eventKey];

  static String? teamIdFrom(BuildContext context) =>
      GoRouter.maybeOf(context)?.state.uri.queryParameters[teamKey];
}
