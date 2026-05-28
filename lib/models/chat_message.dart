part of '../main.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String sender;
  final String senderId;
  final String message;
  final DateTime createdAt;

  factory ChatMessage.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final senderProfile = json['sender'];
    final senderName = senderProfile is Map<String, dynamic>
        ? (senderProfile['full_name'] ?? 'Mentor') as String
        : 'Mentor';
    return ChatMessage(
      id: (json['id'] ?? '') as String,
      sender: json['sender_id'] == currentUserId ? 'Me' : senderName,
      senderId: (json['sender_id'] ?? '') as String,
      message: (json['message'] ?? '') as String,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
