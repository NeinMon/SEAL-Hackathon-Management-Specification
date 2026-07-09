import '../../../shared.dart';

class OrganizerEventTile extends StatelessWidget {
  const OrganizerEventTile({
    super.key,
    required this.event,
    required this.dateRangeLabel,
    required this.onEdit,
    required this.onCloseRegistration,
  });

  final HackathonEvent event;
  final String dateRangeLabel;
  final VoidCallback onEdit;
  final VoidCallback onCloseRegistration;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.event_available_outlined),
        title: Text(event.title),
        subtitle: Text('${event.location}\n$dateRangeLabel'),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          tooltip: context.l10n.eventActionsTooltip,
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'close') onCloseRegistration();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(context.l10n.editEventMenuItem),
              ),
            ),
            PopupMenuItem(
              value: 'close',
              child: ListTile(
                leading: const Icon(Icons.lock_clock_outlined),
                title: Text(context.l10n.closeRegistrationMenuItem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
