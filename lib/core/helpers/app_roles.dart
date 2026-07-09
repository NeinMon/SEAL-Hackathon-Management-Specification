import '../l10n/l10n_service.dart';

class AppRoles {
  const AppRoles._();

  static const participant = 'participant';
  static const judge = 'judge';
  static const mentor = 'mentor';
  static const organizer = 'organizer';

  static const participantCreators = {participant, organizer};
  static const scorers = {judge};
  static const judgeAccess = {judge, organizer};

  static String label(String role) {
    return switch (role) {
      participant => L10nService.strings.roleParticipant,
      judge => L10nService.strings.roleJudge,
      mentor => L10nService.strings.roleMentor,
      organizer => L10nService.strings.roleOrganizer,
      _ => role,
    };
  }
}
