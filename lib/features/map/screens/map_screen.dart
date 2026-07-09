import '../../../shared.dart';
import '../widgets/map_screen_body.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final auth = context.watch<AuthProvider>().user;
    final routeEventId = RouteQuery.eventIdFrom(context);
    final activeEvent = context.watch<ActiveEventProvider>().eventFor(
      events: eventProvider.events,
      routeEventId: routeEventId,
      userId: auth?.id,
      teams: context.watch<TeamProvider>().teams,
    );

    return MapScreenBody(
      eventProvider: eventProvider,
      activeEvent: activeEvent,
      onEventChanged: (eventId) {
        context.read<ActiveEventProvider>().setFromUserPick(eventId);
        setState(() {});
      },
    );
  }
}
