import '../core/l10n/l10n_service.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/notification_link.dart';
import '../core/app_helpers.dart';
import '../core/route_query.dart';
import '../core/supabase_config.dart';
import '../models/app_notification.dart';
import '../models/app_user.dart';
import '../models/team.dart';
import '../services/push_notification_service.dart';
import '../services/supabase_services.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = const NotificationService();
  static const int pageSize = 20;
  List<AppNotification> notifications = [];
  int _visibleCount = pageSize;
  bool isLoading = false;
  String? error;
  RealtimeChannel? _realtimeChannel;
  String? _watchedUserId;
  String _watchedUserRole = AppRoles.participant;
  bool bellHighlight = false;
  AppNotification? pendingScoreAlert;

  void clearScoreAlert() {
    if (!bellHighlight && pendingScoreAlert == null) return;
    bellHighlight = false;
    pendingScoreAlert = null;
    notifyListeners();
  }

  List<AppNotification> get visibleNotifications =>
      notifications.take(_visibleCount).toList();

  bool get hasMoreNotifications => notifications.length > _visibleCount;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  void loadMoreNotifications() {
    if (!hasMoreNotifications) return;
    _visibleCount += pageSize;
    notifyListeners();
  }

  void _resetVisibleCount() {
    _visibleCount = pageSize;
  }

  Future<void> loadForUser(String userId) async {
    final userError = AppValidators.requireUserId(userId);
    if (userError != null) {
      error = userError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      notifications = await _service.fetchForUser(userId);
      _resetVisibleCount();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void watchForUser(String userId, {String role = AppRoles.participant}) {
    if (!SupabaseGateway.isReady) {
      _watchedUserRole = role;
      unawaited(loadForUser(userId));
      return;
    }
    if (_watchedUserId == userId &&
        _watchedUserRole == role &&
        _realtimeChannel != null) {
      return;
    }
    _stopRealtime();
    _watchedUserId = userId;
    _watchedUserRole = role;
    _realtimeChannel = SupabaseGateway.client
        .channel('notifications-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => unawaited(_refreshSilently(userId)),
        )
        .subscribe();
    unawaited(loadForUser(userId));
  }

  Future<void> _refreshSilently(String userId) async {
    try {
      final previousIds = notifications.map((item) => item.id).toSet();
      final previousUnread = unreadCount;
      notifications = await _service.fetchForUser(userId);
      _resetVisibleCount();
      error = null;
      final latestUnread = notifications
          .where((notification) => !notification.isRead)
          .toList();
      final newUnread = notifications
          .where((notification) => !previousIds.contains(notification.id))
          .where((notification) => !notification.isRead)
          .toList();
      if (latestUnread.length > previousUnread && latestUnread.isNotEmpty) {
        final latest = latestUnread.first;
        final route = latest.deepRoute?.trim().isNotEmpty == true
            ? latest.deepRoute!.trim()
            : NotificationLink.routeFor(
                latest,
                role: _watchedUserRole,
                userId: userId,
              );
        final actionLabel = latest.actionLabel?.trim().isNotEmpty == true
            ? latest.actionLabel!.trim()
            : NotificationLink.actionLabelFor(
                latest,
                role: _watchedUserRole,
              );
        await PushNotificationService.instance.showInAppAlert(
          title: latest.title,
          body: NotificationLink.displayContent(latest.content),
          payload: route,
          actionLabel: actionLabel,
        );
      }
      final newScore = newUnread
          .where((notification) => notification.type == 'score')
          .toList();
      if (newScore.isNotEmpty) {
        pendingScoreAlert = newScore.first;
        bellHighlight = true;
      }
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  Future<void> push(
    String title,
    String content,
    String type, {
    String? userId,
    String? actionLabel,
    String? deepRoute,
  }) async {
    error = null;
    final validationError = AppValidators.notificationPayload(
      userId: userId,
      title: title,
      content: content,
      type: type,
    );
    if (validationError != null) {
      error = validationError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    try {
      final targetUserId = userId!;
      await _service.create(
        userId: targetUserId,
        title: title.trim(),
        content: content.trim(),
        type: type,
        actionLabel: actionLabel,
        deepRoute: deepRoute,
      );
      if (SupabaseGateway.client.auth.currentUser?.id == targetUserId) {
        await loadForUser(targetUserId);
      }
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  Future<void> notifyTeamCreated({
    required String userId,
    required String teamName,
    required String eventTitle,
    required String eventId,
  }) {
    return push(
      L10nService.strings.teamCreatedNotificationTitle,
      NotificationLink.encodeEvent(
        eventId: eventId,
        content: L10nService.strings.teamCreatedNotificationBody(teamName, eventTitle),
      ),
      'system',
      userId: userId,
      actionLabel: L10nService.strings.notificationActionGoTeams,
      deepRoute: RouteQuery.teamsForEvent(eventId),
    );
  }

  Future<void> notifySubmissionSaved({
    required Team team,
    required String projectName,
  }) async {
    final eventId = team.eventId;
    final recipients = team.members.map((member) => member.id).toSet()
      ..removeWhere((id) => id.isEmpty);
    for (final recipientId in recipients) {
      await push(
        L10nService.strings.submissionSavedNotificationTitle,
        NotificationLink.encodeEvent(
          eventId: eventId,
          content: L10nService.strings.submissionSavedNotificationBody(projectName),
        ),
        'system',
        userId: recipientId,
        actionLabel: L10nService.strings.notificationActionSubmit,
        deepRoute: RouteQuery.submitForEvent(eventId, teamId: team.id),
      );
      if (error != null) return;
    }
  }

  Future<void> requestMentorAssignment({
    required AppUser participant,
    required String eventId,
    required String eventTitle,
  }) async {
    final organizers = await const UserDirectoryService().fetchUsersByRole(
      AppRoles.organizer,
    );
    final body = NotificationLink.encodeEvent(
      eventId: eventId,
      content: L10nService.strings.chatMentorRequestTemplate,
    );
    for (final organizer in organizers) {
      await push(
        L10nService.strings.mentorRequestNotificationTitle(participant.fullName),
        body,
        'system',
        userId: organizer.id,
        actionLabel: L10nService.strings.notificationActionViewEvent,
        deepRoute: RouteQuery.organizerForEvent(eventId),
      );
      if (error != null) return;
    }
  }

  Future<void> markRead(String id) async {
    error = null;
    try {
      await _service.markRead(id);
      notifications.firstWhere((notification) => notification.id == id).isRead =
          true;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  Future<void> deleteNotification(String id) async {
    error = null;
    try {
      await _service.deleteNotification(id);
      notifications.removeWhere((notification) => notification.id == id);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  void _stopRealtime() {
    final channel = _realtimeChannel;
    _realtimeChannel = null;
    _watchedUserId = null;
    if (channel != null) {
      unawaited(SupabaseGateway.client.removeChannel(channel));
    }
  }

  void clear() {
    _stopRealtime();
    notifications = [];
    error = null;
    isLoading = false;
    bellHighlight = false;
    pendingScoreAlert = null;
    _resetVisibleCount();
    notifyListeners();
  }
}
