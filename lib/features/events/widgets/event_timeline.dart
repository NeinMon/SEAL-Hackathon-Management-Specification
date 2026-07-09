import '../../../shared.dart';

class EventTimelineItem {
  const EventTimelineItem({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime date;
}

class EventTimeline extends StatelessWidget {
  const EventTimeline({super.key, required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final items = [
      EventTimelineItem(
        icon: Icons.how_to_reg_outlined,
        label: L10nService.strings.timelineRegistration,
        date: event.registrationDeadline,
      ),
      EventTimelineItem(
        icon: Icons.flag_outlined,
        label: L10nService.strings.timelineKickoff,
        date: event.startDate,
      ),
      EventTimelineItem(
        icon: Icons.emoji_events_outlined,
        label: L10nService.strings.timelineFinal,
        date: event.endDate,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.sealTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.sealTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.strings.timelineTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(item.icon, color: context.sealPrimary),
                  const SizedBox(width: AppSizes.paddingSmall + 2),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(item.date),
                    style: TextStyle(
                      color: context.sealTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
