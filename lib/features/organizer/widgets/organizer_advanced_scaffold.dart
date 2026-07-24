import '../../../shared.dart';
import 'organizer_section_picker.dart';

class OrganizerAdvancedScaffold extends StatelessWidget {
  const OrganizerAdvancedScaffold({
    super.key,
    required this.section,
    required this.focusEventTitle,
    required this.loading,
    required this.onSectionChanged,
    required this.onBack,
    required this.onRefresh,
    required this.child,
  });

  static const sections = [
    'overview',
    'operations',
    'events',
    'teams',
    'submissions',
  ];

  final String section;
  final String? focusEventTitle;
  final bool loading;
  final ValueChanged<String> onSectionChanged;
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;
  final Widget child;

  static int indexFor(String value) {
    final index = sections.indexOf(value);
    return index < 0 ? 0 : index;
  }

  static String _label(BuildContext context, String value) {
    switch (value) {
      case 'operations':
        return context.l10n.sectionOperations;
      case 'events':
        return context.l10n.sectionEvents;
      case 'teams':
        return context.l10n.sectionTeams;
      case 'submissions':
        return context.l10n.sectionSubmissions;
      default:
        return context.l10n.sectionOverview;
    }
  }

  static IconData _icon(String value) {
    switch (value) {
      case 'operations':
        return Icons.tune_outlined;
      case 'events':
        return Icons.event_outlined;
      case 'teams':
        return Icons.groups_outlined;
      case 'submissions':
        return Icons.assignment_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;

    return Column(
      children: [
        CompactShellHeader(
          onBack: onBack,
          backTooltip: context.l10n.organizerHideDetailsButton,
          title: focusEventTitle == null
              ? L10nService.strings.organizerTitle
              : focusEventTitle!,
          subtitle: _label(context, section),
          showSubtitleOnCompact: true,
          trailing: [
            IconButton.filledTonal(
              visualDensity: VisualDensity.compact,
              tooltip: context.l10n.reloadDashboardTooltip,
              onPressed: loading ? null : onRefresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        if (!compact) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingMedium,
              AppSizes.paddingCompact,
              AppSizes.paddingMedium,
              0,
            ),
            child: OrganizerSectionPicker(
              value: section,
              onChanged: onSectionChanged,
            ),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        Expanded(child: child),
        if (compact)
          CompactShellNavBar(
            selectedIndex: indexFor(section),
            onDestinationSelected: (index) =>
                onSectionChanged(sections[index]),
            destinations: [
              for (final value in sections)
                NavigationDestination(
                  icon: Icon(_icon(value)),
                  label: _label(context, value),
                ),
            ],
          ),
      ],
    );
  }
}
