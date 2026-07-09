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
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.go(RouteQuery.overviewForEvent(event.id)),
                  child: Text(context.l10n.detailsButton),
                ),
              ],
            ),
            const SizedBox(height: 12),
            JourneyStepper(journey: journey),
            if (journey.averageScore != null) ...[
              const SizedBox(height: 10),
              Text(
                context.l10n.journeyScoreSummaryFormatted(journey.averageScore!),
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
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => journey.navigatePrimary(context),
              icon: Icon(journey.primaryActionIcon),
              label: Text(journey.primaryActionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
