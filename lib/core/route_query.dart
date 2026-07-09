import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_routes.dart';
import '../models/team.dart';

class RouteQuery {
  const RouteQuery._();

  static const eventKey = 'event';
  static const teamKey = 'team';
  static const viewKey = 'view';
  static const viewScore = 'score';

  static String overviewForEvent(String eventId) =>
      AppRoutes.eventOverview(eventId);

  static String teamsForEvent(String eventId) => AppRoutes.eventTeam(eventId);

  static String chatForEvent(String eventId) => AppRoutes.eventChat(eventId);

  static String submitForEvent(
    String eventId, {
    String? teamId,
    String? view,
  }) {
    final params = <String, String>{};
    if (teamId != null && teamId.isNotEmpty) params[teamKey] = teamId;
    if (view != null && view.isNotEmpty) params[viewKey] = view;
    final base = AppRoutes.eventSubmit(eventId);
    if (params.isEmpty) return base;
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$base?$query';
  }

  static String judgeForEvent(String eventId) => AppRoutes.eventJudge(eventId);

  static String? teamEventId(List<Team> teams, String teamId) {
    for (final team in teams) {
      if (team.id == teamId) return team.eventId;
    }
    return null;
  }

  static String? redirectFlatSubmit(List<Team> teams, String teamId) {
    final eventId = teamEventId(teams, teamId);
    if (eventId == null) return null;
    return submitForEvent(eventId, teamId: teamId);
  }

  static String submitForTeam(String teamId, {String? eventId}) {
    if (eventId != null && eventId.isNotEmpty) {
      return submitForEvent(eventId, teamId: teamId);
    }
    return '${AppRoutes.submit}?$teamKey=$teamId';
  }

  static String mapForEvent(String eventId) => AppRoutes.eventMap(eventId);

  static String organizerForEvent(String eventId) =>
      '${AppRoutes.organizer}?$eventKey=$eventId';

  static String? eventIdFrom(BuildContext context) {
    final state = GoRouter.maybeOf(context)?.state;
    if (state == null) return null;
    final fromPath = state.pathParameters['eventId'];
    if (fromPath != null && fromPath.isNotEmpty) return fromPath;
    return state.uri.queryParameters[eventKey];
  }

  static bool isEventScopedPath(String path) {
    return RegExp(r'^/events/[^/]+/(overview|team|submit|chat|map|judge)$')
        .hasMatch(path);
  }

  static String? teamIdFrom(BuildContext context) =>
      GoRouter.maybeOf(context)?.state.uri.queryParameters[teamKey];

  static bool isScoreView(BuildContext context) =>
      GoRouter.maybeOf(context)?.state.uri.queryParameters[viewKey] ==
      viewScore;
}
