import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_notification.dart';
import '../services/supabase_services.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = const NotificationService();
  List<AppNotification> notifications = [];
  bool isLoading = false;
  String? error;
  RealtimeChannel? _realtimeChannel;
  String? _watchedUserId;

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
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void watchForUser(String userId) {
    if (!SupabaseGateway.isReady) {
      unawaited(loadForUser(userId));
      return;
    }
    if (_watchedUserId == userId && _realtimeChannel != null) return;
    _stopRealtime();
    _watchedUserId = userId;
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
      notifications = await _service.fetchForUser(userId);
      error = null;
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
      );
      if (SupabaseGateway.client.auth.currentUser?.id == targetUserId) {
        await loadForUser(targetUserId);
      }
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
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
    notifyListeners();
  }
}