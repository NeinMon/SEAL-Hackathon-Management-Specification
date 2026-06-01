part of '../../main.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final search = TextEditingController();

  @override
  void initState() {
    super.initState();
    search.addListener(_refreshSearchUi);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  void dispose() {
    search
      ..removeListener(_refreshSearchUi)
      ..dispose();
    super.dispose();
  }

  void _refreshSearchUi() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final hasActiveQuery =
        search.text.trim().isNotEmpty || provider.filter != 'all';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Events',
          subtitle:
              'Find hackathons, follow deadlines, and open event details.',
          icon: Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Refresh events',
            onPressed: provider.isLoading ? null : provider.loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (provider.error != null)
          StatusBanner(message: provider.error!, isError: true),
        TextField(
          controller: search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search by title, location, or topic',
            suffixIcon: search.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      search.clear();
                      provider.updateSearch('');
                    },
                    icon: const Icon(Icons.close),
                  ),
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
                label: 'All',
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
          const LoadingCardList(itemCount: 3)
        else if (provider.filteredEvents.isEmpty)
          EmptyState(
            message: hasActiveQuery
                ? 'No events match the current search.'
                : 'No events available.',
            actionLabel: hasActiveQuery ? 'Clear search' : 'Reload events',
            onAction: hasActiveQuery
                ? () {
                    search.clear();
                    provider.updateSearch('');
                    provider.updateFilter('all');
                  }
                : provider.loadEvents,
          )
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
    final phase = _phaseFor(event);
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
                    child: StatusPill(
                      label: phase.label,
                      color: phase.color,
                      icon: phase.icon,
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
                        icon: Icons.schedule_outlined,
                        text:
                            'Register by ${formatter.format(event.registrationDeadline)}',
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
                          'Open for team registration',
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

  _EventPhase _phaseFor(HackathonEvent event) {
    final now = DateTime.now();
    if (event.endDate.isBefore(now)) {
      return const _EventPhase(
        'Closed',
        SealPalette.onSurfaceVariant,
        Icons.lock_clock_outlined,
      );
    }
    if (event.startDate.isAfter(now)) {
      return const _EventPhase(
        'Upcoming',
        SealPalette.tertiary,
        Icons.upcoming_outlined,
      );
    }
    return const _EventPhase(
      'Active',
      SealPalette.secondary,
      Icons.bolt_outlined,
    );
  }
}

class _EventPhase {
  const _EventPhase(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}
