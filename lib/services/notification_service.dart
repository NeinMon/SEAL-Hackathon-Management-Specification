import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_notification.dart';

class NotificationService {
  const NotificationService();

  Future<List<AppNotification>> fetchForUser(String userId) async {
    return AppOperation.run('notifications.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    });
  }

  Future<void> create({
    required String userId,
    required String title,
    required String content,
    required String type,
    String? actionLabel,
    String? deepRoute,
  }) {
    AppLogger.action('notification.create', {'user_id': userId, 'type': type});
    return AppOperation.run('notifications.create', () {
      return SupabaseGateway.client.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'content': content,
        'notification_type': type,
        if (actionLabel != null && actionLabel.isNotEmpty)
          'action_label': actionLabel,
        if (deepRoute != null && deepRoute.isNotEmpty) 'deep_route': deepRoute,
      });
    });
  }

  Future<void> markRead(String id) {
    return AppOperation.run('notifications.mark_read', () {
      return SupabaseGateway.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', id);
    });
  }

  Future<void> deleteNotification(String id) {
    return AppOperation.run('notifications.delete', () {
      return SupabaseGateway.client.from('notifications').delete().eq('id', id);
    });
  }
}
