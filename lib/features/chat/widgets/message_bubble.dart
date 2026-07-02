import '../../../shared.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  final ChatMessage message;
  final AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    final mine = message.senderId == currentUser?.id;
    final seal = context.sealTheme;
    final senderLabel = mine ? AppStrings.yourMessageSemantic : message.sender;
    return Semantics(
      label: AppStrings.messageTimestampSemantic(
        senderLabel,
        DateFormat('HH:mm').format(message.createdAt),
      ),
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
                  : seal.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingCompact),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mine ? AppStrings.meLabel : message.sender,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(message.message),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('HH:mm').format(message.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: seal.onSurfaceVariant,
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
        title: const Text(AppStrings.deleteMessageTitle),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.deleteButton),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;
    await context.read<ChatProvider>().deleteMessage(message, userId);
  }
}
