import '../../shared.dart';

class EventScopePicker extends StatelessWidget {
  const EventScopePicker({
    super.key,
    required this.events,
    required this.selectedEventId,
    required this.onChanged,
    this.label,
    this.showAllOption = false,
  });

  final List<HackathonEvent> events;
  final String? selectedEventId;
  final ValueChanged<String?> onChanged;
  final String? label;
  final bool showAllOption;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    final sortedEvents = EventSort.sorted(events);
    if (sortedEvents.length == 1 && !showAllOption) {
      return Align(
        alignment: Alignment.centerLeft,
        child: StatusPill(
          label: sortedEvents.first.title,
          color: context.sealPrimary,
          icon: Icons.event_outlined,
        ),
      );
    }
    return DropdownButtonFormField<String?>(
      isExpanded: true,
      initialValue: selectedEventId ?? (showAllOption ? null : sortedEvents.first.id),
      decoration: InputDecoration(
        labelText: label ?? context.l10n.eventLabel,
        prefixIcon: const Icon(Icons.event_outlined),
      ),
      items: [
        if (showAllOption)
          DropdownMenuItem<String?>(
            value: null,
            child: Text(context.l10n.allEventsFilter),
          ),
        for (final event in sortedEvents)
          DropdownMenuItem<String?>(
            value: event.id,
            child: Text(event.title, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
