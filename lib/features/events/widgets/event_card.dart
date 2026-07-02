import '../../../shared.dart';
import 'event_meta_pill.dart';
import 'event_phase.dart';
import 'event_status_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final phase = eventPhaseFor(event);
    final registrationOpen = eventRegistrationOpen(event);
    return Semantics(
      button: true,
      label: AppStrings.openEventSemanticLabel(event.title),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.sectionGap),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/events/${event.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 7,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventNetworkImage(url: event.bannerUrl, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xAA060E20)],
                        ),
                      ),
                    ),
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
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: SealPalette.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sectionGap),
                    Wrap(
                      spacing: AppSizes.paddingSmall,
                      runSpacing: AppSizes.paddingSmall,
                      children: [
                        EventMetaPill(
                          icon: Icons.calendar_month,
                          value:
                              '${formatter.format(event.startDate)} - ${formatter.format(event.endDate)}',
                        ),
                        EventMetaPill(
                          icon: Icons.schedule_outlined,
                          value: AppStrings.registerBeforeDate(
                            formatter.format(event.registrationDeadline),
                          ),
                        ),
                        EventMetaPill(
                          icon: Icons.place_outlined,
                          value: event.location,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingMedium),
                    Row(
                      children: [
                        Expanded(
                          child: StatusPill(
                            label: registrationOpen
                                ? AppStrings.registerTeamPill
                                : AppStrings.registrationClosedPill,
                            color: registrationOpen
                                ? SealPalette.secondary
                                : SealPalette.onSurfaceVariant,
                            icon: registrationOpen
                                ? Icons.groups_2_outlined
                                : Icons.lock_clock_outlined,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => context.go('/events/${event.id}'),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text(AppStrings.detailsButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
