import '../l10n/l10n_service.dart';
import '../route_query.dart';
import 'announcement_templates.dart';
import '../helpers/app_roles.dart';

class OrganizerTaskTemplate {
  const OrganizerTaskTemplate({
    required this.announcement,
    this.actionLabel,
    this.deepRoute,
  });

  final AnnouncementTemplate announcement;
  final String? actionLabel;
  final String? deepRoute;
}

class OrganizerTaskTemplates {
  OrganizerTaskTemplates._();

  static OrganizerTaskTemplate unscoredReminder({
    required int count,
    required String eventId,
    required String eventTitle,
  }) {
    return OrganizerTaskTemplate(
      announcement: AnnouncementTemplate(
        label: L10nService.strings.organizerTaskUnscoredLabel,
        title: L10nService.strings.organizerTaskUnscoredTitle(eventTitle),
        content: L10nService.strings.organizerTaskUnscoredBody(count),
        role: AppRoles.judge,
      ),
      actionLabel: L10nService.strings.notificationActionOpenJudge,
      deepRoute: RouteQuery.judgeForEvent(eventId),
    );
  }

  static OrganizerTaskTemplate teamsNeedMembersReminder({
    required int count,
    required String eventId,
    required String eventTitle,
  }) {
    return OrganizerTaskTemplate(
      announcement: AnnouncementTemplate(
        label: L10nService.strings.organizerTaskTeamsLabel,
        title: L10nService.strings.organizerTaskTeamsTitle(eventTitle),
        content: L10nService.strings.organizerTaskTeamsBody(count),
        role: AppRoles.participant,
      ),
      actionLabel: L10nService.strings.notificationActionGoTeams,
      deepRoute: RouteQuery.teamsForEvent(eventId),
    );
  }

  static OrganizerTaskTemplate closingSoonReminder({
    required int count,
    required String eventId,
    required String eventTitle,
  }) {
    return OrganizerTaskTemplate(
      announcement: AnnouncementTemplate(
        label: L10nService.strings.organizerTaskClosingLabel,
        title: L10nService.strings.organizerTaskClosingTitle(eventTitle),
        content: L10nService.strings.organizerTaskClosingBody(count),
        role: AppRoles.participant,
      ),
      actionLabel: L10nService.strings.notificationActionViewEvent,
      deepRoute: RouteQuery.overviewForEvent(eventId),
    );
  }
}
