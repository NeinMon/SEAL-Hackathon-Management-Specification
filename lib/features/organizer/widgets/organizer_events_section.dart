import '../../../shared.dart';
import 'organizer_event_tile.dart';

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
        Text(
          L10nService.strings.sectionEvents,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (events.events.isEmpty)
          EmptyState(
            message: L10nService.strings.noEventsYet,
            icon: Icons.event_busy_outlined,
            actionLabel: L10nService.strings.createEventTitle,
            onAction: onCreateEvent,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.sortedEvents.take(4).length,
            itemBuilder: (context, index) {
              final event = events.sortedEvents[index];
              return OrganizerEventTile(
                event: event,
                dateRangeLabel: formatDateRange(event),
                onEdit: () => onEditEvent(event),
                onCloseRegistration: () => onCloseRegistration(event),
              );
            },
          ),
      ],
    );
  }
}
