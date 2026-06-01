part of '../main.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = const ChatService();
  List<AppUser> contacts = [];
  AppUser? selectedContact;
  List<ChatMessage> messages = [];
  bool isLoading = false;
  bool isSending = false;
  String? error;

  Future<void> loadContacts(AppUser currentUser) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      contacts = await _service.fetchContacts(currentUser);
      if (selectedContact == null ||
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

  Future<void> send(
    String sender,
    String message, {
    String? senderId,
    String? receiverId,
  }) async {
    if (isSending) return;
    if (message.trim().isEmpty) {
      error = 'Message cannot be empty.';
      notifyListeners();
      return;
    }
    error = null;
    if (senderId == null || receiverId == null) {
      error = 'Select a conversation before sending a message.';
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

  void clear() {
    contacts = [];
    selectedContact = null;
    messages = [];
    error = null;
    isLoading = false;
    isSending = false;
    notifyListeners();
  }
}
