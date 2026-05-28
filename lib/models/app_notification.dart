part of '../main.dart';

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String content;
  final String type;
  bool isRead;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      type: (json['notification_type'] ?? 'system') as String,
      isRead: (json['is_read'] ?? false) as bool,
    );
  }
}
