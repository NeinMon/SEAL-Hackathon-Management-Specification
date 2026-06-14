import '../../../shared.dart';
import '../widgets/chat_composer.dart';
import '../widgets/empty_chat_state.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  String? composerError;

  @override
  void initState() {
    super.initState();
    controller.addListener(_refreshComposer);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        final chat = context.read<ChatProvider>();
        chat.loadContacts(user).then((_) {
          final contact = chat.selectedContact;
          if (contact != null) {
            chat.watchConversation(user.id, contact.id);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller
      ..removeListener(_refreshComposer)
      ..dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _refreshComposer() {
    if (!mounted) return;
    final validationError = AppValidators.chatMessage(controller.text);
    setState(() {
      if (controller.text.trim().isEmpty) {
        composerError = null;
      } else if (validationError != null) {
        composerError = validationError;
      } else {
        composerError = null;
      }
    });
  }

  Future<void> _sendMessage() async {
    final user = context.read<AuthProvider>().user;
    final chat = context.read<ChatProvider>();
    final validationError = AppValidators.chatMessage(controller.text);
    if (validationError != null) {
      setState(() => composerError = validationError);
      return;
    }
    setState(() => composerError = null);
    await chat.send(
      user!.fullName,
      controller.text,
      senderId: user.id,
      receiverId: chat.selectedContact!.id,
    );
    controller.clear();
    _scrollToLatest();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final user = context.watch<AuthProvider>().user;
    final messages = [...chat.messages]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatest());
    }
    return RoleGate(
      allowedRoles: const {
        AppRoles.participant,
        AppRoles.mentor,
        AppRoles.organizer,
      },
      message: AppStrings.chatRoleGateMessage,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: SealSectionHeader(
              title: AppStrings.chatTitle,
              subtitle: AppStrings.chatSubtitle,
              icon: Icons.chat_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingCompact,
              0,
              AppSizes.paddingCompact,
              AppSizes.paddingCompact,
            ),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              key: ValueKey(
                'chat-contact-${chat.selectedContact?.id}-${chat.contacts.length}',
              ),
              initialValue: chat.selectedContact?.id,
              decoration: const InputDecoration(
                labelText: AppStrings.chatContactLabel,
                prefixIcon: Icon(Icons.support_agent_outlined),
              ),
              items: [
                for (final contact in chat.contacts)
                  DropdownMenuItem(
                    value: contact.id,
                    child: Text(
                      '${contact.fullName} (${contact.role})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: user == null || chat.isLoading
                  ? null
                  : (contactId) {
                      final contact = chat.contacts.firstWhere(
                        (item) => item.id == contactId,
                      );
                      chat.selectContact(contact);
                      chat.watchConversation(user.id, contact.id);
                    },
            ),
          ),
          if (chat.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ErrorState(
                message: chat.error!,
                onRetry: user == null || chat.selectedContact == null
                    ? null
                    : () => chat.watchConversation(
                        user.id,
                        chat.selectedContact!.id,
                      ),
              ),
            ),
          if (chat.contacts.isEmpty)
            const StatusBanner(
              message: AppStrings.noChatContactsMessage,
              isError: true,
            ),
          Expanded(
            child: chat.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(AppSizes.paddingMedium),
                    child: ChatSkeleton(),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSizes.paddingMedium),
                    itemCount: messages.isEmpty ? 1 : messages.length + 2,
                    itemBuilder: (context, index) {
                      if (messages.isEmpty) {
                        return const EmptyChatState();
                      }
                      if (index == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: StatusPill(
                              label: AppStrings.todayTimestamp(
                                DateFormat('HH:mm').format(DateTime.now()),
                              ),
                              color: SealPalette.onSurfaceVariant,
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
                  ),
          ),
          ChatComposer(
            controller: controller,
            error: composerError,
            isSending: chat.isSending,
            canSend:
                user != null &&
                chat.selectedContact != null &&
                !chat.isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _scrollToLatest() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }
}
