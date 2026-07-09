import '../l10n/l10n_service.dart';
import '../../models/hackathon_event.dart';
import '../../models/project_submission.dart';
import '../../models/team.dart';
import '../team_membership.dart';
import '../../providers/score_provider.dart';

enum ParticipantJourneyStep {
  needsTeam,
  needsSubmission,
  awaitingScore,
  hasScore,
  registrationClosed,
  missedSubmission,
}

class ParticipantJourney {
  const ParticipantJourney({
    required this.step,
    required this.event,
    this.team,
    this.submission,
    this.averageScore,
  });

  final ParticipantJourneyStep step;
  final HackathonEvent event;
  final Team? team;
  final ProjectSubmission? submission;
  final double? averageScore;

  static ParticipantJourney? forUser({
    required HackathonEvent event,
    required String? userId,
    required List<Team> teams,
    required List<ProjectSubmission> submissions,
    required ScoreProvider scores,
  }) {
    if (userId == null) return null;
    final team = TeamMembership.teamForUserOnEvent(
      teams: teams,
      userId: userId,
      eventId: event.id,
    );
    if (team == null) {
      return ParticipantJourney(
        step: event.registrationOpen()
            ? ParticipantJourneyStep.needsTeam
            : ParticipantJourneyStep.registrationClosed,
        event: event,
      );
    }
    final submission = _latestSubmission(submissions, team.id);
    if (submission == null) {
      return ParticipantJourney(
        step: event.submissionOpen()
            ? ParticipantJourneyStep.needsSubmission
            : ParticipantJourneyStep.missedSubmission,
        event: event,
        team: team,
      );
    }
    final scoreCount = scores.scoreCountFor(submission.id);
    if (scoreCount > 0) {
      return ParticipantJourney(
        step: ParticipantJourneyStep.hasScore,
        event: event,
        team: team,
        submission: submission,
        averageScore: scores.averageFor(submission.id),
      );
    }
    return ParticipantJourney(
      step: ParticipantJourneyStep.awaitingScore,
      event: event,
      team: team,
      submission: submission,
    );
  }

  static ProjectSubmission? _latestSubmission(
    List<ProjectSubmission> submissions,
    String teamId,
  ) {
    ProjectSubmission? latest;
    for (final submission in submissions) {
      if (submission.teamId != teamId) continue;
      if (latest == null ||
          submission.submittedAt.isAfter(latest.submittedAt)) {
        latest = submission;
      }
    }
    return latest;
  }
}

extension ParticipantJourneyLabels on ParticipantJourneyStep {
  String get label => switch (this) {
    ParticipantJourneyStep.needsTeam => L10nService.strings.journeyStepNeedsTeam,
    ParticipantJourneyStep.needsSubmission => L10nService.strings.journeyStepNeedsSubmission,
    ParticipantJourneyStep.awaitingScore => L10nService.strings.journeyStepAwaitingScore,
    ParticipantJourneyStep.hasScore => L10nService.strings.journeyStepHasScore,
    ParticipantJourneyStep.missedSubmission =>
      L10nService.strings.journeyStepMissedSubmission,
    ParticipantJourneyStep.registrationClosed =>
      L10nService.strings.journeyStepRegistrationClosed,
  };
}
