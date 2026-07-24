import '../../../shared.dart';
import 'event_card.dart';

class EventSearchField extends StatelessWidget {
  const EventSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: L10nService.strings.eventSearchHint,
        suffixIcon: controller.text.trim().isEmpty
            ? null
            : IconButton(
                tooltip: context.l10n.clearSearchAction,
                onPressed: onClear,
                icon: Icon(Icons.close),
              ),
      ),
      onChanged: onChanged,
    );
  }
}

class EventFilterBar extends StatelessWidget {
  const EventFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in EventCatalog.filterLabels.entries) ...[
            CommandChip(
              label: entry.value,
              selected: selectedFilter == entry.key,
              onTap: () => onFilterChanged(entry.key),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
          ],
        ],
      ),
    );
  }
}

class EventSortDropdown extends StatelessWidget {
  const EventSortDropdown({
    super.key,
    required this.value,
    required this.isLoading,
    required this.onChanged,
  });

  final String value;
  final bool isLoading;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.sort_outlined,
          size: 20,
          color: context.sealTheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: DropdownButtonFormField<String>(
            key: const Key('event_sort_dropdown'),
            isExpanded: true,
            initialValue: value,
            decoration: InputDecoration(
              labelText: L10nService.strings.sortLabel,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingCompact,
                vertical: 10,
              ),
            ),
            items: [
              for (final entry in EventCatalog.sortLabels.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: isLoading
                ? null
                : (sort) {
                    if (sort != null) onChanged(sort);
                  },
          ),
        ),
      ],
    );
  }
}

class EventListBody extends StatelessWidget {
  const EventListBody({
    super.key,
    required this.provider,
    required this.hasActiveQuery,
    required this.onResetFilters,
  });

  final EventProvider provider;
  final bool hasActiveQuery;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: AppSizes.sectionGap),
          child: EventCardSkeleton(),
        ),
      );
    }
    if (provider.filteredEvents.isEmpty) {
      return EmptyState(
        message: hasActiveQuery
            ? L10nService.strings.noMatchingEvents
            : L10nService.strings.noEventsYet,
        actionLabel: hasActiveQuery
            ? L10nService.strings.clearSearchAction
            : L10nService.strings.reloadEventsAction,
        onAction: hasActiveQuery ? onResetFilters : provider.loadEvents,
      );
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.visibleFilteredEvents.length,
          itemBuilder: (context, index) =>
              EventCard(event: provider.visibleFilteredEvents[index]),
        ),
        if (provider.hasMoreEvents)
          LoadMoreButton(onPressed: provider.loadMoreEvents),
      ],
    );
  }
}
