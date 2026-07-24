import '../../../shared.dart';
import '../widgets/event_list_toolbar.dart';
import '../widgets/event_list_filters_sheet.dart';
import '../widgets/participant_home_section.dart';

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

  Future<void> _refresh(EventProvider provider) async {
    await provider.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final auth = context.watch<AuthProvider>().user;
    final hasActiveQuery = provider.hasActiveFilters;
    final compact = MediaQuery.sizeOf(context).width < 760;

    return RefreshableListView(
      onRefresh: () => _refresh(provider),
      children: [
        SealSectionHeader(
          title: auth?.role == AppRoles.participant
              ? L10nService.strings.participantHomeTitle
              : L10nService.strings.eventsTitle,
          subtitle: auth?.role == AppRoles.participant
              ? L10nService.strings.participantHomeSubtitle
              : L10nService.strings.eventsSubtitle,
          icon: auth?.role == AppRoles.participant
              ? Icons.home_outlined
              : Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: context.l10n.reloadEventsAction,
            onPressed: provider.isLoading ? null : provider.loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ),
        if (auth?.role == AppRoles.participant) ...[
          const ParticipantHomeSection(),
          const SizedBox(height: AppSizes.paddingMedium),
          Text(
            L10nService.strings.allEventsSectionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        if (auth?.role == AppRoles.judge)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingCompact),
            child: StatusBanner(
              message: L10nService.strings.judgeEventListHint,
              isError: false,
            ),
          ),
        if (auth?.role == AppRoles.mentor)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingCompact),
            child: StatusBanner(
              message: L10nService.strings.mentorEventListHint,
              isError: false,
            ),
          ),
        if (provider.error != null && provider.events.isEmpty)
          ErrorState(message: provider.error!, onRetry: provider.loadEvents)
        else if (provider.error != null)
          StatusBanner(message: provider.error!, isError: true),
        if (provider.searchError != null)
          StatusBanner(message: provider.searchError!, isError: true),
        Row(
          children: [
            Expanded(
              child: EventSearchField(
                controller: search,
                onChanged: provider.updateSearch,
                onClear: () {
                  search.clear();
                  provider.updateSearch('');
                },
              ),
            ),
            if (compact) ...[
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: L10nService.strings.sortLabel,
                onPressed: provider.isLoading
                    ? null
                    : () => EventListFiltersSheet.show(
                          context,
                          provider: provider,
                          currentSort: provider.sort,
                        ),
                icon: Badge(
                  isLabelVisible:
                      hasActiveQuery && provider.filter != EventCatalog.filterAll,
                  child: const Icon(Icons.tune_outlined),
                ),
              ),
            ],
          ],
        ),
        if (!compact) ...[
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
        ],
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
