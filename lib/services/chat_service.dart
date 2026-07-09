import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import 'event_mentor_service.dart';

class ChatService {
  const ChatService();

  Future<List<AppUser>> fetchContacts(
    AppUser currentUser, {
    String? eventId,
  }) async {
    return AppOperation.run('chat.contacts', () async {
      switch (currentUser.role) {
        case AppRoles.participant:
          if (eventId != null && eventId.isNotEmpty) {
            return const EventMentorService().fetchMentorsForParticipantOnEvent(
              userId: currentUser.id,
              eventId: eventId,
            );
          }
          return const EventMentorService().fetchMentorsForParticipant(
            currentUser.id,
          );
        case AppRoles.mentor:
          if (eventId != null && eventId.isNotEmpty) {
            return const EventMentorService().fetchParticipantsForMentorOnEvent(
              mentorId: currentUser.id,
              eventId: eventId,
            );
          }
          return const EventMentorService().fetchParticipantsForMentor(
            currentUser.id,
          );
        default:
          return const [];
      }
    });
  }

  Future<List<ChatMessage>> fetchConversation(
    String userId,
    String receiverId,
  ) async {
    return AppOperation.run('chat.conversation', () async {
      final rows = await SupabaseGateway.client
          .from('messages')
          .select('*,sender:users!messages_sender_id_fkey(full_name)')
          .or(
            'and(sender_id.eq.$userId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$userId)',
          )
          .order('created_at');
      return rows
          .whereType<Map<String, dynamic>>()
          .map((row) => ChatMessage.fromJson(row, userId))
          .toList();
    });
  }

  Future<void> send({
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    AppLogger.action('chat.send', {
      'sender_id': senderId,
      'receiver_id': receiverId,
    });
    return AppOperation.run('chat.send', () {
      return SupabaseGateway.client.from('messages').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message.trim(),
      });
    });
  }

  Future<void> deleteMessage(String id) {
    return AppOperation.run('chat.delete', () {
      return SupabaseGateway.client.from('messages').delete().eq('id', id);
    });
  }
}
