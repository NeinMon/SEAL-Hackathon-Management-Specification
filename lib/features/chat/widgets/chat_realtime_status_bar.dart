import '../../../shared.dart';

class ChatRealtimeStatusBar extends StatelessWidget {
  const ChatRealtimeStatusBar({
    super.key,
    required this.chat,
    required this.user,
    required this.onRefresh,
  });

  final ChatProvider chat;
  final AppUser? user;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: StatusPill(
              label: chat.isRealtimeConnected
                  ? L10nService.strings.chatRealtimeConnected
                  : chat.isRealtimeConnecting
                  ? L10nService.strings.chatRealtimeConnecting
                  : L10nService.strings.chatRealtimeOffline,
              color: chat.isRealtimeConnected
                  ? context.sealSecondary
                  : context.sealTheme.onSurfaceVariant,
              icon: chat.isRealtimeConnected
                  ? Icons.sync_outlined
                  : Icons.sync_problem_outlined,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: context.l10n.reloadChatTooltip,
            onPressed: user == null || chat.selectedContact == null
                ? null
                : onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
