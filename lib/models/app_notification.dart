class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionLabel,
    this.deepRoute,
  });

  final String id;
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;
  bool isRead;
  final String? actionLabel;
  final String? deepRoute;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      type: (json['notification_type'] ?? 'system') as String,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
      isRead: (json['is_read'] ?? false) as bool,
      actionLabel: json['action_label'] as String?,
      deepRoute: json['deep_route'] as String?,
    );
  }
}
