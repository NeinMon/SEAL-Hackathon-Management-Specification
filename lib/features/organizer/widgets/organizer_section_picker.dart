import '../../../shared.dart';

class OrganizerSectionPicker extends StatelessWidget {
  const OrganizerSectionPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CommandChip(
            label: L10nService.strings.sectionOverview,
            selected: value == 'overview',
            onTap: () => onChanged('overview'),
            icon: Icons.dashboard_outlined,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          CommandChip(
            label: L10nService.strings.sectionOperations,
            selected: value == 'operations',
            onTap: () => onChanged('operations'),
            icon: Icons.tune_outlined,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          CommandChip(
            label: L10nService.strings.sectionEvents,
            selected: value == 'events',
            onTap: () => onChanged('events'),
            icon: Icons.event_outlined,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          CommandChip(
            label: L10nService.strings.sectionTeams,
            selected: value == 'teams',
            onTap: () => onChanged('teams'),
            icon: Icons.groups_outlined,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          CommandChip(
            label: L10nService.strings.sectionSubmissions,
            selected: value == 'submissions',
            onTap: () => onChanged('submissions'),
            icon: Icons.assignment_outlined,
          ),
        ],
      ),
    );
  }
}
