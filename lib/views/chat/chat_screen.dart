part of '../../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

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
            chat.load(user.id, contact.id);
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
    if (mounted) setState(() {});
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
      message: 'Chat is available for participants, mentors, and organizers.',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: SealSectionHeader(
              title: 'Mentor Chat',
              subtitle:
                  'Coordinate with mentors and organizers during the contest.',
              icon: Icons.chat_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              key: ValueKey(
                'chat-contact-${chat.selectedContact?.id}-${chat.contacts.length}',
              ),
              initialValue: chat.selectedContact?.id,
              decoration: const InputDecoration(
                labelText: 'Chat with mentor / organizer',
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
                      chat.load(user.id, contact.id);
                    },
            ),
          ),
          if (chat.error != null)
            StatusBanner(message: chat.error!, isError: true),
          if (chat.contacts.isEmpty)
            const StatusBanner(
              message:
                  'No mentor or organizer account found. Create a mentor account to chat.',
              isError: true,
            ),
          Expanded(
            child: chat.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingCardList(itemCount: 3),
                  )
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (messages.isEmpty)
                        const EmptyState(message: 'No messages yet')
                      else ...[
                        Center(
                          child: StatusPill(
                            label:
                                'Today, ${DateFormat('HH:mm').format(DateTime.now())}',
                            color: SealPalette.onSurfaceVariant,
                            icon: Icons.schedule_outlined,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final message in messages)
                          _MessageBubble(message: message, currentUser: user),
                      ],
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask a mentor...',
                      prefixIcon: Icon(Icons.chat_bubble_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send',
                  onPressed:
                      user == null ||
                          chat.selectedContact == null ||
                          chat.isLoading ||
                          chat.isSending ||
                          controller.text.trim().isEmpty
                      ? null
                      : () async {
                          await chat.send(
                            user.fullName,
                            controller.text,
                            senderId: user.id,
                            receiverId: chat.selectedContact!.id,
                          );
                          controller.clear();
                          _scrollToLatest();
                        },
                  icon: chat.isSending
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.currentUser});

  final ChatMessage message;
  final AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    final mine = message.senderId == currentUser?.id;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: GestureDetector(
          onLongPress: mine && currentUser != null
              ? () => _confirmDelete(context, currentUser!.id)
              : null,
          child: Card(
            color: mine
                ? SealPalette.primaryContainer.withValues(alpha: 0.95)
                : SealPalette.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mine ? 'Me' : message.sender,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(message.message),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: SealPalette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String userId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This removes your message from the conversation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;
    await context.read<ChatProvider>().deleteMessage(message, userId);
  }
}
