import '../../../shared.dart';
import '../widgets/event_list_toolbar.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final search = TextEditingController();

  @override
  void initState() {
    super.initState();
    search.addListener(_refreshSearchUi);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  void dispose() {
    search
      ..removeListener(_refreshSearchUi)
      ..dispose();
    super.dispose();
  }

  void _refreshSearchUi() {
    if (mounted) setState(() {});
  }

  void _resetFilters(EventProvider provider) {
    search.clear();
    provider.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final hasActiveQuery = provider.hasActiveFilters;
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: AppStrings.eventsTitle,
          subtitle: AppStrings.eventsSubtitle,
          icon: Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: AppStrings.reloadEventsAction,
            onPressed: provider.isLoading ? null : provider.loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (provider.error != null && provider.events.isEmpty)
          ErrorState(message: provider.error!, onRetry: provider.loadEvents)
        else if (provider.error != null)
          StatusBanner(message: provider.error!, isError: true),
        if (provider.searchError != null)
          StatusBanner(message: provider.searchError!, isError: true),
        EventSearchField(
          controller: search,
          onChanged: provider.updateSearch,
          onClear: () {
            search.clear();
            provider.updateSearch('');
          },
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        EventFilterBar(
          selectedFilter: provider.filter,
          onFilterChanged: provider.updateFilter,
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        EventSortDropdown(
          value: provider.sort,
          isLoading: provider.isLoading,
          onChanged: provider.updateSort,
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        EventListBody(
          provider: provider,
          hasActiveQuery: hasActiveQuery,
          onResetFilters: () => _resetFilters(provider),
        ),
      ],
    );
  }
}
