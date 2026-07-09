import '../../../shared.dart';

class ChatEmptyContactsPanel extends StatelessWidget {
  const ChatEmptyContactsPanel({
    super.key,
    required this.user,
    required this.onCopyTemplate,
    required this.onSendMentorRequest,
  });

  final AppUser? user;
  final VoidCallback onCopyTemplate;
  final VoidCallback onSendMentorRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        children: [
          EmptyState(
            message: L10nService.strings.noChatContactsMessage,
            icon: Icons.support_agent_outlined,
            actionLabel: L10nService.strings.contactOrganizerForMentorAction,
            onAction: onCopyTemplate,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: user == null ? null : onSendMentorRequest,
            icon: const Icon(Icons.send_outlined),
            label: Text(context.l10n.sendMentorRequestAction),
          ),
        ],
      ),
    );
  }
}
