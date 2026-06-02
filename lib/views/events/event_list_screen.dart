import '../../shared.dart';

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
          subtitle: 'Theo dõi hackathon, deadline và thông tin chi tiết.',
          icon: Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Tải lại Events',
            onPressed: provider.isLoading ? null : provider.loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (provider.error != null && provider.events.isEmpty)
          ErrorState(message: provider.error!, onRetry: provider.loadEvents)
        else if (provider.error != null)
          StatusBanner(message: provider.error!, isError: true),
        TextField(
          controller: search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Tìm theo tên, địa điểm hoặc chủ đề',
            suffixIcon: search.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Xóa tìm kiếm',
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
                label: 'Sắp diễn ra',
                selected: provider.filter == 'upcoming',
                onTap: () => provider.updateFilter('upcoming'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Đang mở',
                selected: provider.filter == 'active',
                onTap: () => provider.updateFilter('active'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Tất cả',
                selected: provider.filter == 'all',
                onTap: () => provider.updateFilter('all'),
              ),
              const SizedBox(width: 8),
              CommandChip(
                label: 'Đã đóng',
                selected: provider.filter == 'closed',
                onTap: () => provider.updateFilter('closed'),
                icon: Icons.tune,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (provider.isLoading)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: EventCardSkeleton(),
            ),
          )
        else if (provider.filteredEvents.isEmpty)
          EmptyState(
            message: hasActiveQuery
                ? 'Không có event phù hợp.'
                : 'Chưa có event.',
            actionLabel: hasActiveQuery ? 'Xóa tìm kiếm' : 'Tải lại Events',
            onAction: hasActiveQuery
                ? () {
                    search.clear();
                    provider.updateSearch('');
                    provider.updateFilter('all');
                  }
                : provider.loadEvents,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.filteredEvents.length,
            itemBuilder: (context, index) =>
                EventCard(event: provider.filteredEvents[index]),
          ),
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
    return Semantics(
      button: true,
      label: 'Mở event ${event.title}',
      child: Card(
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
                    EventNetworkImage(url: event.bannerUrl, fit: BoxFit.cover),
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
                      left: 14,
                      top: 14,
                      child: _EventStatusBadge(phase: phase),
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
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _EventMetaPill(
                          icon: Icons.calendar_month,
                          value:
                              '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}',
                        ),
                        _EventMetaPill(
                          icon: Icons.schedule_outlined,
                          value:
                              'Đăng ký trước ${formatter.format(event.registrationDeadline)}',
                        ),
                        _EventMetaPill(
                          icon: Icons.place_outlined,
                          value: event.location,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: StatusPill(
                            label: 'Đăng ký team',
                            color: SealPalette.secondary,
                            icon: Icons.groups_2_outlined,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => context.go('/events/${event.id}'),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Chi tiết'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _EventPhase _phaseFor(HackathonEvent event) {
    final now = DateTime.now();
    if (event.endDate.isBefore(now)) {
      return const _EventPhase(
        'Đã đóng',
        SealPalette.onSurfaceVariant,
        Icons.lock_clock_outlined,
      );
    }
    if (event.startDate.isAfter(now)) {
      return const _EventPhase(
        'Sắp diễn ra',
        SealPalette.tertiary,
        Icons.upcoming_outlined,
      );
    }
    return const _EventPhase(
      'Đang mở',
      SealPalette.secondary,
      Icons.bolt_outlined,
    );
  }
}

class _EventStatusBadge extends StatelessWidget {
  const _EventStatusBadge({required this.phase});

  final _EventPhase phase;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SealPalette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: phase.color.withValues(alpha: 0.56)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(phase.icon, size: 16, color: phase.color),
            const SizedBox(width: 6),
            Text(
              phase.label,
              style: TextStyle(
                color: phase.color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventMetaPill extends StatelessWidget {
  const _EventMetaPill({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: SealPalette.primary),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: SealPalette.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventPhase {
  const _EventPhase(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}
