import '../../../shared.dart';
import 'journey_stepper.dart';

class ParticipantHomeCard extends StatelessWidget {
  const ParticipantHomeCard({super.key, required this.journey});

  final ParticipantJourney journey;

  @override
  Widget build(BuildContext context) {
    final event = journey.event;
    final helper = journey.helperText;
    final seal = context.sealTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.flag_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: context.l10n.detailsButton,
                  onPressed: () =>
                      context.go(RouteQuery.overviewForEvent(event.id)),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 12),
            JourneyStepper(journey: journey),
            if (journey.averageScore != null) ...[
              const SizedBox(height: 10),
              Text(
                context.l10n.journeyScoreSummaryFormatted(
                  journey.averageScore!,
                ),
                style: TextStyle(
                  color: seal.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (helper != null) ...[
              const SizedBox(height: 10),
              Text(
                helper,
                style: TextStyle(
                  color: seal.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
