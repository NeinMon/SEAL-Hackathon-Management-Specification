part of '../main.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = const NotificationService();
  List<AppNotification> notifications = [];
  bool isLoading = false;
  String? error;

  Future<void> loadForUser(String userId) async {
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

  Future<void> push(
    String title,
    String content,
    String type, {
    String? userId,
  }) async {
    error = null;
    try {
      if (userId == null) return;
      await _service.create(
        userId: userId,
        title: title,
        content: content,
        type: type,
      );
      if (SupabaseGateway.client.auth.currentUser?.id == userId) {
        await loadForUser(userId);
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

  void clear() {
    notifications = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
