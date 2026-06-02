import '../../shared.dart';

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
            title: 'Địa điểm',
            subtitle: 'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.',
            icon: Icons.map_outlined,
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
            title: 'Địa điểm',
            subtitle: 'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.',
            icon: Icons.map_outlined,
          ),
          ErrorState(
            message: eventProvider.error!,
            onRetry: eventProvider.loadEvents,
          ),
        ],
      );
    }
    if (eventProvider.events.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SealSectionHeader(
            title: 'Địa điểm',
            subtitle: 'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.',
            icon: Icons.map_outlined,
          ),
          EmptyState(message: 'Chưa có địa điểm event.'),
        ],
      );
    }
    final event = eventProvider.events.first;
    final position = LatLng(event.latitude, event.longitude);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SealSectionHeader(
          title: 'Địa điểm',
          subtitle: 'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.',
          icon: Icons.map_outlined,
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
                const SizedBox(height: 14),
                Text(
                  event.location,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                _VenueInfoTile(
                  icon: Icons.place_outlined,
                  label: 'Địa chỉ',
                  value: event.location,
                ),
                const _VenueInfoTile(
                  icon: Icons.access_time_outlined,
                  label: 'Giờ mở',
                  value: '08:00 - 18:00',
                ),
                const _VenueInfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Hotline',
                  value: '0900 000 000',
                ),
                _VenueInfoTile(
                  icon: Icons.gps_fixed_outlined,
                  label: 'Tọa độ',
                  value: '${event.latitude}, ${event.longitude}',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _copyAddress(context, event.location),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy địa chỉ'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _confirmExternalMap(context, event),
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Mở Maps'),
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
        title: const Text('Mở Maps bên ngoài?'),
        content: const Text(
          'Bạn sẽ rời SEAL Hackathon tạm thời. Dùng nút Back hoặc Recent Apps để quay lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Mở Maps'),
          ),
        ],
      ),
    );
    if (shouldOpen != true) return;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}';
    await ExternalLauncher.openUrl(url);
  }

  Future<void> _copyAddress(BuildContext context, String location) async {
    await Clipboard.setData(ClipboardData(text: location));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã copy địa chỉ.')));
  }
}

class _VenueInfoTile extends StatelessWidget {
  const _VenueInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SealPalette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SealPalette.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: SealPalette.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
