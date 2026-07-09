/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class ChatStrings {
  ChatStrings._();
  // Chat
  static const String chatRoleGateMessage =
      'Chat khả dụng cho thí sinh, mentor và ban tổ chức.';
  static const String chatTitle = 'Chat mentor';
  static const String chatSubtitle =
      'Trao đổi với mentor và ban tổ chức trong cuộc thi.';
  static const String chatContactLabel = 'Chat với mentor / ban tổ chức';
  static const String noChatContactsMessage =
      'Chưa có tài khoản mentor hoặc ban tổ chức để chat.';
  static const String chatInputHint = 'Hỏi mentor...';
  static const String sendMessageTooltip = 'Gửi';
  static const String yourMessageSemantic = 'Tin nhắn của bạn';
  static const String deleteMessageTitle = 'Xóa tin nhắn?';
  static const String deleteMessageBody =
      'Tin nhắn của bạn sẽ bị xóa khỏi cuộc trò chuyện.';
  static const String noMessagesYet = 'Chưa có tin nhắn.';
  static const String selectConversationBeforeSend =
      'Chọn cuộc trò chuyện trước khi gửi tin nhắn.';

  static String todayTimestamp(String time) => 'Hôm nay, $time';
}
