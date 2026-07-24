import '../../../shared.dart';

class JudgeQueueToolbar extends StatelessWidget {
  const JudgeQueueToolbar({
    super.key,
    required this.filter,
    required this.sort,
    required this.search,
    required this.unscoredCount,
    required this.scoredCount,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final String filter;
  final String sort;
  final TextEditingController search;
  final int unscoredCount;
  final int scoredCount;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final hasSearch = search.text.trim().isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: CommandChip(
            label: '${L10nService.strings.filterUnscored} ($unscoredCount)',
            selected: filter == 'unscored',
            onTap: () => onFilterChanged('unscored'),
            icon: Icons.pending_actions_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommandChip(
            label: '${L10nService.strings.filterScored} ($scoredCount)',
            selected: filter == 'scored',
            onTap: () => onFilterChanged('scored'),
            icon: Icons.verified_outlined,
          ),
        ),
        IconButton.filledTonal(
          tooltip: L10nService.strings.judgeSearchLabel,
          onPressed: () => _openSearchSheet(context),
          icon: Icon(hasSearch ? Icons.manage_search : Icons.search),
        ),
        PopupMenuButton<String>(
          tooltip: L10nService.strings.judgeQueueSortLabel,
          icon: const Icon(Icons.more_vert),
          onSelected: onSortChanged,
          itemBuilder: (context) => [
            _sortItem(context, 'queue', context.l10n.sortNewestFirst),
            _sortItem(context, 'project', context.l10n.sortProjectName),
            _sortItem(context, 'team', context.l10n.sortTeamName),
            _sortItem(context, 'score', context.l10n.sortAverageScore),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _sortItem(
    BuildContext context,
    String value,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (sort == value)
            Icon(Icons.check, size: 18, color: context.sealPrimary)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  Future<void> _openSearchSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _JudgeSearchSheet(initialQuery: search.text),
    );
    if (result == null) return;
    search.text = result;
  }
}

class _JudgeSearchSheet extends StatefulWidget {
  const _JudgeSearchSheet({required this.initialQuery});

  final String initialQuery;

  @override
  State<_JudgeSearchSheet> createState() => _JudgeSearchSheetState();
}

class _JudgeSearchSheetState extends State<_JudgeSearchSheet> {
  late final TextEditingController _query;

  @override
  void initState() {
    super.initState();
    _query = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_query.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingMedium,
        0,
        AppSizes.paddingMedium,
        MediaQuery.viewInsetsOf(context).bottom + AppSizes.paddingMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _query,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10nService.strings.judgeSearchLabel,
              prefixIcon: const Icon(Icons.search),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _submit,
            child: Text(L10nService.strings.judgeSearchLabel),
          ),
        ],
      ),
    );
  }
}
