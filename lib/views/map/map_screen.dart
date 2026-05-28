part of '../../main.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    if (eventProvider.events.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SealSectionHeader(
            title: 'Venue Map',
            subtitle: 'OpenStreetMap marker and external navigation support.',
            icon: Icons.map_outlined,
          ),
          EmptyState(message: 'No event location available.'),
        ],
      );
    }
    final event = eventProvider.events.first;
    final position = LatLng(event.latitude, event.longitude);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Venue Map',
          subtitle: 'OpenStreetMap marker and external navigation support.',
          icon: Icons.map_outlined,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 56),
                const SizedBox(height: 12),
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
                          userAgentPackageName:
                              'com.example.seal_hackathon_app',
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
                              onTap: () => launchUrl(
                                Uri.parse(
                                  'https://www.openstreetmap.org/copyright',
                                ),
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
                const Text('Hotline: 0900 000 000'),
                const Text('Working time: 08:00 - 18:00'),
                Text('Lat/Lng: ${event.latitude}, ${event.longitude}'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}',
                    );
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Open External Maps'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
