part of '../../main.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    if (eventProvider.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Venue',
            subtitle: 'Map marker and external navigation support.',
            icon: Icons.map_outlined,
            trailing: IconButton.filledTonal(
              tooltip: 'Refresh venue',
              onPressed: null,
              icon: Icon(Icons.refresh),
            ),
          ),
          const LoadingCardList(itemCount: 2),
        ],
      );
    }
    if (eventProvider.error != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SealSectionHeader(
            title: 'Venue',
            subtitle: 'Map marker and external navigation support.',
            icon: Icons.map_outlined,
            trailing: IconButton.filledTonal(
              tooltip: 'Refresh venue',
              onPressed: eventProvider.loadEvents,
              icon: const Icon(Icons.refresh),
            ),
          ),
          StatusBanner(message: eventProvider.error!, isError: true),
        ],
      );
    }
    if (eventProvider.events.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SealSectionHeader(
            title: 'Venue',
            subtitle: 'Map marker and external navigation support.',
            icon: Icons.map_outlined,
            trailing: IconButton.filledTonal(
              tooltip: 'Refresh venue',
              onPressed: eventProvider.loadEvents,
              icon: const Icon(Icons.refresh),
            ),
          ),
          EmptyState(
            message: 'No event location available.',
            actionLabel: 'Reload venue',
            onAction: eventProvider.loadEvents,
          ),
        ],
      );
    }
    final event = eventProvider.events.first;
    final position = LatLng(event.latitude, event.longitude);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Venue',
          subtitle: 'Map marker and external navigation support.',
          icon: Icons.map_outlined,
          trailing: IconButton.filledTonal(
            tooltip: 'Refresh venue',
            onPressed: eventProvider.isLoading
                ? null
                : eventProvider.loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: position,
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'vn.seal.hackathon',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: position,
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.location_pin,
                                size: 52,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              onTap: () => ExternalLauncher.openUrl(
                                'https://www.openstreetmap.org/copyright',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  event.location,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const InfoChip(
                      icon: Icons.phone_outlined,
                      text: '0900 000 000',
                    ),
                    const InfoChip(
                      icon: Icons.access_time_outlined,
                      text: '08:00 - 18:00',
                    ),
                    InfoChip(
                      icon: Icons.gps_fixed_outlined,
                      text: '${event.latitude}, ${event.longitude}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _confirmExternalMap(context, event),
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Open in Maps'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: event.location),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Address copied.')),
                    );
                  },
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy address'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmExternalMap(
    BuildContext context,
    HackathonEvent event,
  ) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open external Maps?'),
        content: const Text(
          'This leaves SEAL Hackathon. Use Android Back or Recent Apps to return.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay here'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Maps'),
          ),
        ],
      ),
    );
    if (shouldOpen != true) return;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}';
    await ExternalLauncher.openUrl(url);
  }
}
