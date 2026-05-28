part of '../../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        final chat = context.read<ChatProvider>();
        chat.loadContacts().then((_) {
          final contact = chat.selectedContact;
          if (contact != null) {
            chat.load(user.id, contact.id);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final user = context.watch<AuthProvider>().user;
    return RoleGate(
      allowedRoles: const {'participant', 'mentor', 'organizer'},
      message: 'Chat is available for participants, mentors, and organizers.',
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
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
              initialValue: chat.selectedContact?.id,
              decoration: const InputDecoration(
                labelText: 'Chat with mentor / organizer',
                prefixIcon: Icon(Icons.support_agent_outlined),
              ),
              items: [
                for (final contact in chat.contacts)
                  DropdownMenuItem(
                    value: contact.id,
                    child: Text('${contact.fullName} (${contact.role})'),
                  ),
              ],
              onChanged: user == null
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
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: SealPalette.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'TODAY, ${DateFormat('HH:mm').format(DateTime.now())}',
                            style: const TextStyle(
                              color: SealPalette.onSurfaceVariant,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      for (final message in chat.messages)
                        Align(
                          alignment: message.sender == user?.fullName
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: message.sender == user?.fullName
                                ? SealPalette.primaryContainer
                                : SealPalette.surfaceContainerHigh,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.sender,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(message.message),
                                  Text(
                                    DateFormat(
                                      'HH:mm',
                                    ).format(message.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: SealPalette.onSurfaceVariant,
                                    ),
                                  ),
                                  if (message.senderId == user?.id &&
                                      user != null)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        tooltip: 'Delete message',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => chat.deleteMessage(
                                          message,
                                          user.id,
                                        ),
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                      hintText: 'Ask a technical question...',
                      prefixIcon: Icon(Icons.add_circle_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send',
                  onPressed: user == null || chat.selectedContact == null
                      ? null
                      : () async {
                          await chat.send(
                            user.fullName,
                            controller.text,
                            senderId: user.id,
                            receiverId: chat.selectedContact!.id,
                          );
                          controller.clear();
                        },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
