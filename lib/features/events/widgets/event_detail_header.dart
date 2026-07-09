import '../../../shared.dart';
import 'event_phase.dart';
import 'event_status_badge.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader({super.key, required this.event, this.onBack});

  final HackathonEvent event;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final phase = eventPhaseFor(event, null, EventPhaseColors.from(context));
    final registrationOpen = eventRegistrationOpen(event);
    final deadlineLabel = registrationOpen
        ? L10nService.strings.registrationOpenUntilDate(
            DateFormat('dd/MM').format(event.registrationDeadline),
          )
        : L10nService.strings.registrationClosedByDate(
            DateFormat('dd/MM').format(event.registrationDeadline),
          );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 8,
        child: Stack(
          fit: StackFit.expand,
          children: [
            EventNetworkImage(url: event.bannerUrl, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSizes.sectionGap,
              right: AppSizes.sectionGap,
              top: AppSizes.sectionGap,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onBack != null)
                    IconButton.filledTonal(
                      tooltip: context.l10n.backToEventsButton,
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back),
                    ),
                  EventStatusBadge(phase: phase),
                  StatusPill(
                    label: deadlineLabel,
                    color: registrationOpen
                        ? context.sealSecondary
                        : context.sealTheme.onSurfaceVariant,
                    icon: registrationOpen
                        ? Icons.how_to_reg_outlined
                        : Icons.schedule_outlined,
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSizes.sectionGap,
              right: AppSizes.sectionGap,
              bottom: AppSizes.sectionGap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusPill(
                    label: event.location,
                    color: Colors.white,
                    icon: Icons.place_outlined,
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
