import '../../../shared.dart';

class JourneyStepper extends StatelessWidget {
  const JourneyStepper({super.key, required this.journey});

  final ParticipantJourney journey;

  static const _steps = [
    ParticipantJourneyStep.needsTeam,
    ParticipantJourneyStep.needsSubmission,
    ParticipantJourneyStep.awaitingScore,
    ParticipantJourneyStep.hasScore,
  ];

  @override
  Widget build(BuildContext context) {
    if (!journey.usesProgressTrack) {
      return Align(
        alignment: Alignment.centerLeft,
        child: StatusPill(
          label: journey.step.label,
          color: context.sealTheme.onSurfaceVariant,
          icon: Icons.event_busy_outlined,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < _steps.length; index++) ...[
            if (index > 0)
              SizedBox(
                width: 28,
                child: Container(
                  height: 2,
                  color: journey.isTrackStepDone(_steps[index]) ||
                          journey.isTrackStepActive(_steps[index])
                      ? context.sealSecondary
                      : context.sealTheme.outlineVariant,
                ),
              ),
            _JourneyStepDot(
              label: _steps[index].label,
              active: journey.isTrackStepActive(_steps[index]),
              done: journey.isTrackStepDone(_steps[index]),
              failed: journey.step == ParticipantJourneyStep.missedSubmission &&
                  _steps[index] == ParticipantJourneyStep.needsSubmission,
            ),
          ],
        ],
      ),
    );
  }
}

class _JourneyStepDot extends StatelessWidget {
  const _JourneyStepDot({
    required this.label,
    required this.active,
    required this.done,
    this.failed = false,
  });

  final String label;
  final bool active;
  final bool done;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    final color = failed
        ? context.sealError
        : done
        ? context.sealSecondary
        : active
        ? context.sealPrimary
        : seal.onSurfaceVariant;

    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            failed
                ? Icons.close
                : done
                ? Icons.check
                : Icons.circle,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 72,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
