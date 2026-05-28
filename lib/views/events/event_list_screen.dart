part of '../../main.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Event Control',
          subtitle: 'Track active hackathons, deadlines, and locations.',
          icon: Icons.dashboard_outlined,
        ),
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search hackathon events...',
          ),
          onChanged: provider.updateSearch,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommandChip(
                label: 'Upcoming',
                selected: provider.filter == 'upcoming',
                onTap: () => provider.updateFilter('upcoming'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Active',
                selected: provider.filter == 'active',
                onTap: () => provider.updateFilter('active'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Joined',
                selected: provider.filter == 'all',
                onTap: () => provider.updateFilter('all'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Closed',
                selected: provider.filter == 'closed',
                onTap: () => provider.updateFilter('closed'),
                icon: Icons.tune,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (provider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (provider.filteredEvents.isEmpty)
          const EmptyState(message: 'No events available')
        else
          for (final event in provider.filteredEvents) EventCard(event: event),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});
  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/events/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const EventImageFallback(),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xAA060E20)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: SealPalette.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ACTIVE NOW',
                        style: TextStyle(
                          color: SealPalette.onSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      InfoChip(
                        icon: Icons.calendar_month,
                        text:
                            '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}',
                      ),
                      InfoChip(
                        icon: Icons.place_outlined,
                        text: event.location,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: SealPalette.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          '450 Registered',
                          style: TextStyle(
                            color: SealPalette.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 132,
                        child: FilledButton(
                          onPressed: () => context.go('/events/${event.id}'),
                          child: const Text('View Details'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
