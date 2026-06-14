import '../../../shared.dart';

class OrganizerEventsSection extends StatelessWidget {
  const OrganizerEventsSection({
    super.key,
    required this.events,
    required this.onCreateEvent,
    required this.onEditEvent,
    required this.onCloseRegistration,
  });

  final EventProvider events;
  final VoidCallback onCreateEvent;
  final void Function(HackathonEvent event) onEditEvent;
  final void Function(HackathonEvent event) onCloseRegistration;

  static String formatDateRange(HackathonEvent event) {
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          AppStrings.sectionEvents,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (events.events.isEmpty)
          EmptyState(
            message: AppStrings.noEventsYet,
            icon: Icons.event_busy_outlined,
            actionLabel: AppStrings.createEventTitle,
            onAction: onCreateEvent,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.events.take(4).length,
            itemBuilder: (context, index) {
              final event = events.events[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.event_available_outlined),
                  title: Text(event.title),
                  subtitle: Text(
                    '${event.location}\n${formatDateRange(event)}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    tooltip: AppStrings.eventActionsTooltip,
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEditEvent(event);
                      }
                      if (value == 'close') {
                        onCloseRegistration(event);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text(AppStrings.editEventMenuItem),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'close',
                        child: ListTile(
                          leading: Icon(Icons.lock_clock_outlined),
                          title: Text(AppStrings.closeRegistrationMenuItem),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
