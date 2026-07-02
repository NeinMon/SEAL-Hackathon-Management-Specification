import '../../../shared.dart';
import 'event_phase.dart';
import 'event_status_badge.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader({super.key, required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final phase = eventPhaseFor(event);
    final registrationOpen = eventRegistrationOpen(event);
    final deadlineLabel = registrationOpen
        ? AppStrings.registrationOpenUntilDate(
            DateFormat('dd/MM').format(event.registrationDeadline),
          )
        : AppStrings.registrationClosedByDate(
            DateFormat('dd/MM').format(event.registrationDeadline),
          );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                EventNetworkImage(url: event.bannerUrl, fit: BoxFit.cover),
                Positioned(
                  left: AppSizes.sectionGap,
                  top: AppSizes.sectionGap,
                  child: EventStatusBadge(phase: phase),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusPill(
                      label: phase.label,
                      color: phase.color,
                      icon: phase.icon,
                    ),
                    StatusPill(
                      label: deadlineLabel,
                      color: registrationOpen
                          ? SealPalette.secondary
                          : context.sealTheme.onSurfaceVariant,
                      icon: registrationOpen
                          ? Icons.how_to_reg_outlined
                          : Icons.schedule_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingCompact),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: context.onSurfaceColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: TextStyle(
                    color: context.sealTheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
