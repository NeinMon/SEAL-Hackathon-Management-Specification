import '../l10n/l10n_service.dart';

class AnnouncementTemplate {
  const AnnouncementTemplate({
    required this.label,
    required this.title,
    required this.content,
    this.role = 'all',
  });

  final String label;
  final String title;
  final String content;
  final String role;
}

class AnnouncementTemplates {
  AnnouncementTemplates._();

  static List<AnnouncementTemplate> get demo => [
    AnnouncementTemplate(
      label: L10nService.strings.announcementTemplateJudgingLabel,
      title: L10nService.strings.announcementTemplateJudgingTitle,
      content: L10nService.strings.announcementTemplateJudgingBody,
      role: 'judge',
    ),
    AnnouncementTemplate(
      label: L10nService.strings.announcementTemplateDeadlineLabel,
      title: L10nService.strings.announcementTemplateDeadlineTitle,
      content: L10nService.strings.announcementTemplateDeadlineBody,
      role: 'participant',
    ),
    AnnouncementTemplate(
      label: L10nService.strings.announcementTemplateKickoffLabel,
      title: L10nService.strings.announcementTemplateKickoffTitle,
      content: L10nService.strings.announcementTemplateKickoffBody,
    ),
  ];
}
