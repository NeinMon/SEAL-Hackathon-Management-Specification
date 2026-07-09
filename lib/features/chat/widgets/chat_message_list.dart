import '../../../shared.dart';
import 'empty_chat_state.dart';
import 'message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.user,
    required this.chat,
    required this.scrollController,
    required this.onSuggestion,
    required this.onScrollToLatest,
  });

  final List<ChatMessage> messages;
  final AppUser? user;
  final ChatProvider chat;
  final ScrollController scrollController;
  final void Function(String text)? onSuggestion;
  final VoidCallback onScrollToLatest;

  @override
  Widget build(BuildContext context) {
    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onScrollToLatest());
    }

    if (chat.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        child: ChatSkeleton(),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      itemCount: messages.isEmpty ? 1 : messages.length + 2,
      itemBuilder: (context, index) {
        if (messages.isEmpty) {
          return EmptyChatState(onSuggestion: onSuggestion);
        }
        if (index == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: StatusPill(
                label: L10nService.strings.todayTimestamp(
                  DateFormat('HH:mm').format(DateTime.now()),
                ),
                color: context.sealTheme.onSurfaceVariant,
                icon: Icons.schedule_outlined,
              ),
            ),
          );
        }
        if (index == messages.length + 1) {
          return const SizedBox(height: 4);
        }
        return MessageBubble(
          message: messages[index - 1],
          currentUser: user,
        );
      },
    );
  }
}
