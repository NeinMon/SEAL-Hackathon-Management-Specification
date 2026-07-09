import '../../../shared.dart';
import 'journey_stepper.dart';

class EventJourneyBanner extends StatelessWidget {
  const EventJourneyBanner({super.key, required this.journey});

  final ParticipantJourney journey;

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthProvider>().user?.role != AppRoles.participant) {
      return const SizedBox.shrink();
    }

    final helper = journey.helperText;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              L10nService.strings.journeyNextStepTitle,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 12),
            JourneyStepper(journey: journey),
            if (helper != null) ...[
              const SizedBox(height: 10),
              Text(
                helper,
                style: TextStyle(
                  color: context.sealTheme.onSurfaceVariant,
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
