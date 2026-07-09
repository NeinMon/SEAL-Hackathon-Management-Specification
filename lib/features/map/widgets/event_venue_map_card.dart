import '../../../shared.dart';
import 'venue_info_tile.dart';

class EventVenueMapCard extends StatelessWidget {
  const EventVenueMapCard({
    super.key,
    required this.event,
    required this.onCopyAddress,
    required this.onOpenExternalMap,
  });

  final HackathonEvent event;
  final VoidCallback onCopyAddress;
  final VoidCallback onOpenExternalMap;

  @override
  Widget build(BuildContext context) {
    final position = LatLng(event.latitude, event.longitude);
    return Card(
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
              label: L10nService.strings.addressLabel,
              value: event.location,
            ),
            VenueInfoTile(
              icon: Icons.access_time_outlined,
              label: L10nService.strings.openingHoursLabel,
              value: event.displayOpeningHours,
            ),
            VenueInfoTile(
              icon: Icons.phone_outlined,
              label: L10nService.strings.hotlineLabel,
              value: event.displayHotline,
            ),
            VenueInfoTile(
              icon: Icons.gps_fixed_outlined,
              label: L10nService.strings.coordinatesLabel,
              value: '${event.latitude}, ${event.longitude}',
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            FilledButton.icon(
              onPressed: onCopyAddress,
              icon: const Icon(Icons.copy_outlined),
              label: Text(context.l10n.copyAddressButton),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onOpenExternalMap,
              icon: const Icon(Icons.directions_outlined),
              label: Text(context.l10n.openMapsButton),
            ),
          ],
        ),
      ),
    );
  }
}

class MapVenueActions {
  MapVenueActions._();

  static Future<void> copyAddress(BuildContext context, String location) async {
    await Clipboard.setData(ClipboardData(text: location));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.addressCopiedSuccess)),
    );
  }

  static Future<void> confirmExternalMap(
    BuildContext context,
    HackathonEvent event,
  ) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.openExternalMapsTitle),
        content: Text(context.l10n.openExternalMapsBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.stayButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.openMapsButton),
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
        SnackBar(content: Text(context.l10n.openMapsFailed)),
      );
    }
  }
}
