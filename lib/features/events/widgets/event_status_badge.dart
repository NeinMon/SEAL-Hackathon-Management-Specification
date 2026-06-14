import '../../../shared.dart';
import 'event_phase.dart';

class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({super.key, required this.phase});

  final EventPhase phase;

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
