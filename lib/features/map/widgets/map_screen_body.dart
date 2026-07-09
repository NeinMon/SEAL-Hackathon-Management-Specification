import '../../../shared.dart';
import 'event_venue_map_card.dart';

class MapScreenBody extends StatelessWidget {
  const MapScreenBody({
    super.key,
    required this.eventProvider,
    required this.activeEvent,
    required this.onEventChanged,
  });

  final EventProvider eventProvider;
  final HackathonEvent? activeEvent;
  final ValueChanged<String> onEventChanged;

  @override
  Widget build(BuildContext context) {
    if (eventProvider.isLoading) {
      return _scaffold(
        context,
        children: const [LoadingCardList(itemCount: 2)],
      );
    }
    if (eventProvider.error != null) {
      return _scaffold(
        context,
        children: [
          ErrorState(
            message: eventProvider.error!,
            onRetry: eventProvider.loadEvents,
          ),
        ],
      );
    }
    if (eventProvider.events.isEmpty) {
      return _scaffold(
        context,
        children: [EmptyState(message: context.l10n.noVenueYet)],
      );
    }

    final event = activeEvent ?? eventProvider.events.first;
    return _scaffold(
      context,
      children: [
        if (eventProvider.events.length > 1) ...[
          EventScopePicker(
            events: eventProvider.events,
            selectedEventId: event.id,
            onChanged: (value) {
              if (value == null) return;
              onEventChanged(value);
            },
          ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        EventVenueMapCard(
          event: event,
          onCopyAddress: () => MapVenueActions.copyAddress(context, event.location),
          onOpenExternalMap: () => MapVenueActions.confirmExternalMap(context, event),
        ),
      ],
    );
  }

  Widget _scaffold(BuildContext context, {required List<Widget> children}) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: L10nService.strings.mapTitle,
          subtitle: L10nService.strings.mapSubtitle,
          icon: Icons.map_outlined,
        ),
        ...children,
      ],
    );
  }
}
