import '../../../shared.dart';
import 'event_phase.dart';

class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({super.key, required this.phase});

  final EventPhase phase;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: phase.label,
      icon: phase.icon,
      color: phase.color,
    );
  }
}
