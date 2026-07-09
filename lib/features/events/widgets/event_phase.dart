import '../../../shared.dart';

class EventPhase {
  const EventPhase(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

class EventPhaseColors {
  const EventPhaseColors({
    required this.muted,
    required this.warning,
    required this.active,
  });

  final Color muted;
  final Color warning;
  final Color active;

  static const defaults = EventPhaseColors(
    muted: SealPalette.onSurfaceVariant,
    warning: SealPalette.tertiary,
    active: SealPalette.secondary,
  );

  factory EventPhaseColors.from(BuildContext context) {
    return EventPhaseColors(
      muted: context.sealTheme.onSurfaceVariant,
      warning: context.sealTertiary,
      active: context.sealSecondary,
    );
  }
}

EventPhase eventPhaseFor(
  HackathonEvent event, [
  DateTime? at,
  EventPhaseColors colors = EventPhaseColors.defaults,
]) {
  final now = at ?? DateTime.now();
  if (event.endDate.isBefore(now)) {
    return EventPhase(
      L10nService.strings.statusClosed,
      colors.muted,
      Icons.lock_clock_outlined,
    );
  }
  if (event.startDate.isAfter(now)) {
    if (event.registrationOpen(now)) {
      final daysToDeadline = event.registrationDeadline.difference(now).inDays;
      if (daysToDeadline <= 3) {
        return EventPhase(
          L10nService.strings.statusRegistrationClosing,
          colors.warning,
          Icons.hourglass_bottom_outlined,
        );
      }
    }
    return EventPhase(
      L10nService.strings.statusUpcoming,
      colors.warning,
      Icons.upcoming_outlined,
    );
  }
  if (event.submissionOpen(now)) {
    return EventPhase(
      L10nService.strings.statusActive,
      colors.active,
      Icons.bolt_outlined,
    );
  }
  if (event.judgingOpen(now)) {
    return EventPhase(
      L10nService.strings.statusJudging,
      colors.active,
      Icons.gavel_outlined,
    );
  }
  return EventPhase(
    L10nService.strings.statusClosed,
    colors.muted,
    Icons.lock_clock_outlined,
  );
}

bool eventRegistrationOpen(HackathonEvent event, [DateTime? at]) =>
    event.registrationOpen(at);

String? eventRegistrationBlockReason(HackathonEvent event, [DateTime? at]) =>
    event.registrationBlockReason(at);
