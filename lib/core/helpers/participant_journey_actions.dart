import '../l10n/l10n_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/active_event_provider.dart';
import '../constants/app_routes.dart';
import '../route_query.dart';
import 'participant_journey.dart';

extension ParticipantJourneyActions on ParticipantJourney {
  String get primaryActionLabel => switch (step) {
    ParticipantJourneyStep.needsTeam => L10nService.strings.journeyActionJoinTeam,
    ParticipantJourneyStep.registrationClosed =>
      L10nService.strings.journeyActionBrowseEvents,
    ParticipantJourneyStep.needsSubmission => L10nService.strings.journeyActionSubmit,
    ParticipantJourneyStep.missedSubmission =>
      L10nService.strings.journeyActionContactOrganizer,
    ParticipantJourneyStep.awaitingScore =>
      L10nService.strings.journeyActionViewSubmission,
    ParticipantJourneyStep.hasScore => L10nService.strings.journeyActionViewScore,
  };

  String? get helperText => switch (step) {
    ParticipantJourneyStep.registrationClosed =>
      L10nService.strings.journeyHelperRegistrationClosed,
    ParticipantJourneyStep.missedSubmission =>
      L10nService.strings.journeyHelperMissedSubmission,
    _ => null,
  };

  IconData get primaryActionIcon => switch (step) {
    ParticipantJourneyStep.needsTeam => Icons.group_add_outlined,
    ParticipantJourneyStep.registrationClosed => Icons.event_outlined,
    ParticipantJourneyStep.needsSubmission => Icons.upload_file_outlined,
    ParticipantJourneyStep.missedSubmission => Icons.support_agent_outlined,
    ParticipantJourneyStep.awaitingScore => Icons.history_outlined,
    ParticipantJourneyStep.hasScore => Icons.leaderboard_outlined,
  };

  bool get usesProgressTrack =>
      step != ParticipantJourneyStep.registrationClosed;

  int get trackIndex => switch (step) {
    ParticipantJourneyStep.needsTeam => 0,
    ParticipantJourneyStep.registrationClosed => 0,
    ParticipantJourneyStep.needsSubmission => 1,
    ParticipantJourneyStep.missedSubmission => 1,
    ParticipantJourneyStep.awaitingScore => 2,
    ParticipantJourneyStep.hasScore => 3,
  };

  bool isTrackStepDone(ParticipantJourneyStep trackStep) {
    const order = [
      ParticipantJourneyStep.needsTeam,
      ParticipantJourneyStep.needsSubmission,
      ParticipantJourneyStep.awaitingScore,
      ParticipantJourneyStep.hasScore,
    ];
    final current = order.indexOf(
      step == ParticipantJourneyStep.missedSubmission
          ? ParticipantJourneyStep.needsSubmission
          : step == ParticipantJourneyStep.registrationClosed
          ? ParticipantJourneyStep.needsTeam
          : step,
    );
    final track = order.indexOf(trackStep);
    if (step == ParticipantJourneyStep.missedSubmission &&
        trackStep == ParticipantJourneyStep.needsSubmission) {
      return false;
    }
    return track < current;
  }

  bool isTrackStepActive(ParticipantJourneyStep trackStep) {
    if (step == ParticipantJourneyStep.missedSubmission &&
        trackStep == ParticipantJourneyStep.needsSubmission) {
      return true;
    }
    return step == trackStep;
  }

  String trackStepLabel(ParticipantJourneyStep trackStep) {
    if (isTrackStepDone(trackStep)) {
      return trackStep.completedLabel;
    }
    return trackStep.label;
  }

  void navigatePrimary(BuildContext context) {
    context.read<ActiveEventProvider>().setFromUserPick(event.id);
    switch (step) {
      case ParticipantJourneyStep.needsTeam:
        context.go(RouteQuery.teamsForEvent(event.id));
      case ParticipantJourneyStep.registrationClosed:
        context.go(AppRoutes.events);
      case ParticipantJourneyStep.needsSubmission:
        if (team != null) {
          context.go(RouteQuery.submitForEvent(event.id, teamId: team!.id));
        } else {
          context.go(RouteQuery.teamsForEvent(event.id));
        }
      case ParticipantJourneyStep.missedSubmission:
        context.go(AppRoutes.notifications);
      case ParticipantJourneyStep.awaitingScore:
        if (team != null) {
          context.go(RouteQuery.submitForEvent(event.id, teamId: team!.id));
        }
      case ParticipantJourneyStep.hasScore:
        if (team != null) {
          context.go(
            RouteQuery.submitForEvent(
              event.id,
              teamId: team!.id,
              view: RouteQuery.viewScore,
            ),
          );
        }
    }
  }
}
