import '../../../shared.dart';

class ChatContactPicker extends StatelessWidget {
  const ChatContactPicker({
    super.key,
    required this.chat,
    required this.user,
    required this.onContactSelected,
  });

  final ChatProvider chat;
  final AppUser? user;
  final void Function(AppUser contact) onContactSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        decoration: InputDecoration(
          labelText: L10nService.strings.chatContactLabel,
          prefixIcon: const Icon(Icons.support_agent_outlined),
        ),
        items: [
          for (final contact in chat.contacts)
            DropdownMenuItem(
              value: contact.id,
              child: Text(
                '${contact.fullName} (${AppRoles.label(contact.role)})',
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
                onContactSelected(contact);
              },
      ),
    );
  }
}
