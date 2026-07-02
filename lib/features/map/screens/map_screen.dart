import '../../../shared.dart';
import '../widgets/venue_info_tile.dart';

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
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          const SealSectionHeader(
            title: AppStrings.mapTitle,
            subtitle: AppStrings.mapSubtitle,
            icon: Icons.map_outlined,
          ),
          const LoadingCardList(itemCount: 2),
        ],
      );
    }
    if (eventProvider.error != null) {
      return ListView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          const SealSectionHeader(
            title: AppStrings.mapTitle,
            subtitle: AppStrings.mapSubtitle,
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
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          const SealSectionHeader(
            title: AppStrings.mapTitle,
            subtitle: AppStrings.mapSubtitle,
            icon: Icons.map_outlined,
          ),
          const EmptyState(message: AppStrings.noVenueYet),
        ],
      );
    }
    final eventId = RouteQuery.eventIdFrom(context);
    final event = eventId == null
        ? eventProvider.events.first
        : eventProvider.byIdOrNull(eventId) ?? eventProvider.events.first;
    final position = LatLng(event.latitude, event.longitude);
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        const SealSectionHeader(
          title: AppStrings.mapTitle,
          subtitle: AppStrings.mapSubtitle,
          icon: Icons.map_outlined,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
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
                const SizedBox(height: AppSizes.sectionGap),
                Text(
                  event.location,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingCompact),
                VenueInfoTile(
                  icon: Icons.place_outlined,
                  label: AppStrings.addressLabel,
                  value: event.location,
                ),
                const VenueInfoTile(
                  icon: Icons.access_time_outlined,
                  label: AppStrings.openingHoursLabel,
                  value: AppStrings.defaultOpeningHours,
                ),
                const VenueInfoTile(
                  icon: Icons.phone_outlined,
                  label: AppStrings.hotlineLabel,
                  value: AppStrings.defaultHotline,
                ),
                VenueInfoTile(
                  icon: Icons.gps_fixed_outlined,
                  label: AppStrings.coordinatesLabel,
                  value: '${event.latitude}, ${event.longitude}',
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                FilledButton.icon(
                  onPressed: () => _copyAddress(context, event.location),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text(AppStrings.copyAddressButton),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _confirmExternalMap(context, event),
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text(AppStrings.openMapsButton),
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
        title: const Text(AppStrings.openExternalMapsTitle),
        content: const Text(AppStrings.openExternalMapsBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.stayButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.openMapsButton),
          ),
        ],
      ),
    );
    if (shouldOpen != true) return;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}';
    final opened = await ExternalLauncher.openUrl(url);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở Maps trên thiết bị này.')),
      );
    }
  }

  Future<void> _copyAddress(BuildContext context, String location) async {
    await Clipboard.setData(ClipboardData(text: location));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.addressCopiedSuccess)),
    );
  }
}
