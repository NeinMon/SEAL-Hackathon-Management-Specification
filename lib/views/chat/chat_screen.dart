import '../../shared.dart';

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
      message: 'Chat khả dụng cho thí sinh, mentor và ban tổ chức.',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: SealSectionHeader(
              title: 'Mentor Chat',
              subtitle: 'Trao đổi với mentor và ban tổ chức trong cuộc thi.',
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
                labelText: 'Chat với mentor / ban tổ chức',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ErrorState(
                message: chat.error!,
                onRetry: user == null || chat.selectedContact == null
                    ? null
                    : () => chat.load(user.id, chat.selectedContact!.id),
              ),
            ),
          if (chat.contacts.isEmpty)
            const StatusBanner(
              message: 'Chưa có tài khoản mentor hoặc ban tổ chức để chat.',
              isError: true,
            ),
          Expanded(
            child: chat.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: ChatSkeleton(),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.isEmpty ? 1 : messages.length + 2,
                    itemBuilder: (context, index) {
                      if (messages.isEmpty) {
                        return const _EmptyChatState();
                      }
                      if (index == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: StatusPill(
                              label:
                                  'Hôm nay, ${DateFormat('HH:mm').format(DateTime.now())}',
                              color: SealPalette.onSurfaceVariant,
                              icon: Icons.schedule_outlined,
                            ),
                          ),
                        );
                      }
                      if (index == messages.length + 1) {
                        return const SizedBox(height: 4);
                      }
                      return _MessageBubble(
                        message: messages[index - 1],
                        currentUser: user,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SealPalette.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SealPalette.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Hỏi mentor...',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Gửi',
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
    final senderLabel = mine ? 'Tin nhắn của bạn' : message.sender;
    return Semantics(
      label:
          '$senderLabel lúc ${DateFormat('HH:mm').format(message.createdAt)}',
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * (mine ? 0.68 : 0.76),
          ),
          child: GestureDetector(
            onLongPress: mine && currentUser != null
                ? () => _confirmDelete(context, currentUser!.id)
                : null,
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: mine
                  ? SealPalette.primaryContainer.withValues(alpha: 0.95)
                  : SealPalette.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mine ? 'Tôi' : message.sender,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(message.message),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('HH:mm').format(message.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: SealPalette.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
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
        title: const Text('Xóa tin nhắn?'),
        content: const Text('Tin nhắn của bạn sẽ bị xóa khỏi cuộc trò chuyện.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;
    await context.read<ChatProvider>().deleteMessage(message, userId);
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmptyState(
          icon: Icons.chat_bubble_outline,
          message: 'Chưa có tin nhắn.',
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: const [
            StatusPill(label: 'Hỏi về bài nộp'),
            StatusPill(label: 'Review GitHub link'),
            StatusPill(label: 'Checklist demo'),
          ],
        ),
      ],
    );
  }
}
