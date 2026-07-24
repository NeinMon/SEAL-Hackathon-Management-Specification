import '../../../shared.dart';
import 'event_list_toolbar.dart';

class EventListFiltersSheet {
  EventListFiltersSheet._();

  static Future<void> show(
    BuildContext context, {
    required EventProvider provider,
    required String currentSort,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingMedium,
              0,
              AppSizes.paddingMedium,
              AppSizes.paddingMedium,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  L10nService.strings.sortLabel,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                EventSortDropdown(
                  value: currentSort,
                  isLoading: provider.isLoading,
                  onChanged: provider.updateSort,
                ),
                const SizedBox(height: 16),
                Text(
                  L10nService.strings.eventsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                EventFilterBar(
                  selectedFilter: provider.filter,
                  onFilterChanged: (value) {
                    provider.updateFilter(value);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
