import 'app_strings.dart';

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

  static const List<AnnouncementTemplate> demo = [
    AnnouncementTemplate(
      label: AppStrings.announcementTemplateJudgingLabel,
      title: AppStrings.announcementTemplateJudgingTitle,
      content: AppStrings.announcementTemplateJudgingBody,
      role: 'judge',
    ),
    AnnouncementTemplate(
      label: AppStrings.announcementTemplateDeadlineLabel,
      title: AppStrings.announcementTemplateDeadlineTitle,
      content: AppStrings.announcementTemplateDeadlineBody,
      role: 'participant',
    ),
    AnnouncementTemplate(
      label: AppStrings.announcementTemplateKickoffLabel,
      title: AppStrings.announcementTemplateKickoffTitle,
      content: AppStrings.announcementTemplateKickoffBody,
    ),
  ];
}
