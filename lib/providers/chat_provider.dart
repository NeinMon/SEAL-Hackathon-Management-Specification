import '../core/l10n/l10n_service.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../services/supabase_services.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = const ChatService();
  List<AppUser> contacts = [];
  AppUser? selectedContact;
  List<ChatMessage> messages = [];
  bool isLoading = false;
  bool isSending = false;
  bool isRealtimeConnected = false;
  bool isRealtimeConnecting = false;
  String? error;
  RealtimeChannel? _conversationChannel;
  String? _watchedUserId;
  String? _watchedContactId;

  Future<void> loadContacts(AppUser currentUser, {String? eventId}) async {
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
      contacts = await _service.fetchContacts(currentUser, eventId: eventId);
      if (eventId != null && contacts.isNotEmpty) {
        selectedContact = contacts.first;
      } else if (selectedContact == null ||
          !contacts.any((contact) => contact.id == selectedContact!.id)) {
        selectedContact = contacts.isEmpty ? null : contacts.first;
      }
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void selectContact(AppUser contact) {
    selectedContact = contact;
    notifyListeners();
  }

  Future<void> load(String userId, String receiverId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      messages = await _service.fetchConversation(userId, receiverId);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void watchConversation(String userId, String receiverId) {
    if (!SupabaseGateway.isReady) {
      unawaited(load(userId, receiverId));
      return;
    }
    if (_watchedUserId == userId &&
        _watchedContactId == receiverId &&
        _conversationChannel != null) {
      return;
    }
    _stopConversationRealtime();
    _watchedUserId = userId;
    _watchedContactId = receiverId;
    isRealtimeConnecting = true;
    isRealtimeConnected = false;
    notifyListeners();
    _conversationChannel = SupabaseGateway.client
        .channel('messages-$userId-$receiverId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final record = payload.newRecord.isNotEmpty
                ? payload.newRecord
                : payload.oldRecord;
            final senderId = record['sender_id']?.toString();
            final recordReceiverId = record['receiver_id']?.toString();
            final inConversation =
                (senderId == userId && recordReceiverId == receiverId) ||
                (senderId == receiverId && recordReceiverId == userId);
            if (!inConversation) return;
            unawaited(_refreshConversationSilently(userId, receiverId));
          },
        )
        .subscribe((status, [_]) {
          isRealtimeConnecting = false;
          isRealtimeConnected = status == RealtimeSubscribeStatus.subscribed;
          notifyListeners();
        });
    unawaited(load(userId, receiverId));
  }

  Future<void> _refreshConversationSilently(
    String userId,
    String receiverId,
  ) async {
    try {
      messages = await _service.fetchConversation(userId, receiverId);
      error = null;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  Future<void> send(
    String sender,
    String message, {
    String? senderId,
    String? receiverId,
  }) async {
    if (isSending) return;
    final messageError = AppValidators.chatMessage(message);
    if (messageError != null) {
      error = messageError;
      notifyListeners();
      return;
    }
    error = null;
    if (senderId == null || receiverId == null) {
      error = L10nService.strings.selectConversationBeforeSend;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isSending = true;
    notifyListeners();
    try {
      await _service.send(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
      await load(senderId, receiverId);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isSending = false;
    notifyListeners();
  }

  Future<void> deleteMessage(ChatMessage message, String userId) async {
    error = null;
    try {
      await _service.deleteMessage(message.id);
      messages.removeWhere((item) => item.id == message.id);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
  }

  void _stopConversationRealtime() {
    final channel = _conversationChannel;
    _conversationChannel = null;
    _watchedUserId = null;
    _watchedContactId = null;
    isRealtimeConnected = false;
    isRealtimeConnecting = false;
    if (channel != null) {
      unawaited(SupabaseGateway.client.removeChannel(channel));
    }
  }

  void clear() {
    _stopConversationRealtime();
    contacts = [];
    selectedContact = null;
    messages = [];
    error = null;
    isLoading = false;
    isSending = false;
    isRealtimeConnected = false;
    isRealtimeConnecting = false;
    notifyListeners();
  }
}
