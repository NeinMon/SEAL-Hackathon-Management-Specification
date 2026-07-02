import '../../../shared.dart';

class EventPhase {
  const EventPhase(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

EventPhase eventPhaseFor(HackathonEvent event, [DateTime? at]) {
  final now = at ?? DateTime.now();
  if (event.endDate.isBefore(now)) {
    return const EventPhase(
      AppStrings.statusClosed,
      SealPalette.onSurfaceVariant,
      Icons.lock_clock_outlined,
    );
  }
  if (event.startDate.isAfter(now)) {
    return const EventPhase(
      AppStrings.statusUpcoming,
      SealPalette.tertiary,
      Icons.upcoming_outlined,
    );
  }
  return const EventPhase(
    AppStrings.statusActive,
    SealPalette.secondary,
    Icons.bolt_outlined,
  );
}

bool eventRegistrationOpen(HackathonEvent event, [DateTime? at]) =>
    event.registrationOpen(at);

String? eventRegistrationBlockReason(HackathonEvent event, [DateTime? at]) =>
    event.registrationBlockReason(at);
