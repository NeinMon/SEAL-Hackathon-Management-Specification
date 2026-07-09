import '../../../shared.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_contact_picker.dart';
import '../widgets/chat_empty_contacts_panel.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/chat_realtime_status_bar.dart';

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({
    super.key,
    required this.chat,
    required this.user,
    required this.eventTitle,
    required this.messages,
    required this.controller,
    required this.scrollController,
    required this.composerError,
    required this.onContactSelected,
    required this.onRefreshConversation,
    required this.onCopyMentorTemplate,
    required this.onSendMentorRequest,
    required this.onSendMessage,
    required this.onScrollToLatest,
    required this.onSuggestion,
  });

  final ChatProvider chat;
  final AppUser? user;
  final String? eventTitle;
  final List<ChatMessage> messages;
  final TextEditingController controller;
  final ScrollController scrollController;
  final String? composerError;
  final void Function(AppUser contact) onContactSelected;
  final VoidCallback onRefreshConversation;
  final VoidCallback onCopyMentorTemplate;
  final VoidCallback onSendMentorRequest;
  final Future<void> Function() onSendMessage;
  final VoidCallback onScrollToLatest;
  final void Function(String text)? onSuggestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: SealSectionHeader(
            title: L10nService.strings.chatTitle,
            subtitle: eventTitle == null
                ? L10nService.strings.chatSubtitle
                : L10nService.strings.chatEventScopedSubtitle(eventTitle!),
            icon: Icons.chat_outlined,
          ),
        ),
        ChatContactPicker(
          chat: chat,
          user: user,
          onContactSelected: onContactSelected,
        ),
        ChatRealtimeStatusBar(
          chat: chat,
          user: user,
          onRefresh: onRefreshConversation,
        ),
        if (chat.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ErrorState(
              message: chat.error!,
              onRetry: onRefreshConversation,
            ),
          ),
        if (chat.contacts.isEmpty)
          ChatEmptyContactsPanel(
            user: user,
            onCopyTemplate: onCopyMentorTemplate,
            onSendMentorRequest: onSendMentorRequest,
          ),
        Expanded(
          child: ChatMessageList(
            messages: messages,
            user: user,
            chat: chat,
            scrollController: scrollController,
            onSuggestion: onSuggestion,
            onScrollToLatest: onScrollToLatest,
          ),
        ),
        ChatComposer(
          controller: controller,
          error: composerError,
          isSending: chat.isSending,
          canSend: user != null && chat.selectedContact != null && !chat.isLoading,
          onSend: onSendMessage,
        ),
      ],
    );
  }
}

class ChatMentorRequestActions {
  ChatMentorRequestActions._();

  static Future<void> copyTemplate(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: L10nService.strings.chatMentorRequestTemplate),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.contactOrganizerHint)),
    );
  }

  static Future<void> sendRequest(BuildContext context, AppUser user) async {
    final eventId = RouteQuery.eventIdFrom(context);
    if (eventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorEventContextRequired)),
      );
      return;
    }
    final event = context.read<EventProvider>().byIdOrNull(eventId);
    if (event == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorEventContextRequired)),
      );
      return;
    }
    await context.read<NotificationProvider>().requestMentorAssignment(
      participant: user,
      eventId: eventId,
      eventTitle: event.title,
    );
    if (!context.mounted) return;
    final error = context.read<NotificationProvider>().error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? L10nService.strings.mentorRequestSentSuccess,
        ),
      ),
    );
  }
}
