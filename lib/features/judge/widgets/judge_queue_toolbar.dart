import '../../../shared.dart';

class JudgeQueueToolbar extends StatelessWidget {
  const JudgeQueueToolbar({
    super.key,
    required this.filter,
    required this.sort,
    required this.search,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final String filter;
  final String sort;
  final TextEditingController search;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CommandChip(
              label: L10nService.strings.allFilter,
              selected: filter == 'all',
              onTap: () => onFilterChanged('all'),
            ),
            CommandChip(
              label: L10nService.strings.filterUnscored,
              selected: filter == 'unscored',
              onTap: () => onFilterChanged('unscored'),
              icon: Icons.pending_actions_outlined,
            ),
            CommandChip(
              label: L10nService.strings.filterScored,
              selected: filter == 'scored',
              onTap: () => onFilterChanged('scored'),
              icon: Icons.verified_outlined,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: search,
          decoration: InputDecoration(
            labelText: L10nService.strings.judgeSearchLabel,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: search.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: context.l10n.clearSearchAction,
                    onPressed: search.clear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: sort,
          decoration: InputDecoration(
            labelText: L10nService.strings.judgeQueueSortLabel,
            prefixIcon: const Icon(Icons.sort_outlined),
          ),
          items: [
            DropdownMenuItem(
              value: 'queue',
              child: Text(context.l10n.sortNewestFirst),
            ),
            DropdownMenuItem(
              value: 'project',
              child: Text(context.l10n.sortProjectName),
            ),
            DropdownMenuItem(
              value: 'team',
              child: Text(context.l10n.sortTeamName),
            ),
            DropdownMenuItem(
              value: 'score',
              child: Text(context.l10n.sortAverageScore),
            ),
          ],
          onChanged: (value) => onSortChanged(value ?? 'queue'),
        ),
      ],
    );
  }
}
