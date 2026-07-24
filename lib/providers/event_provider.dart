import '../core/l10n/l10n_service.dart';
import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../core/helpers/event_sort.dart';
import '../models/hackathon_event.dart';
import '../services/supabase_services.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = const EventService();
  static const int pageSize = 20;
  List<HackathonEvent> events = [];
  int _visibleCount = pageSize;

  bool isLoading = false;
  String search = '';
  String filter = EventCatalog.filterAll;
  String sort = EventCatalog.sortStartAsc;
  String? message;
  String? error;
  String? searchError;

  bool get hasActiveFilters =>
      search.trim().isNotEmpty ||
      filter != EventCatalog.filterAll ||
      sort != EventCatalog.sortStartAsc;

  List<HackathonEvent> get sortedEvents =>
      EventSort.sorted(events, sort: sort);

  List<HackathonEvent> get filteredEvents {
    final keyword = search.toLowerCase();
    final now = DateTime.now();
    final filtered = events.where((event) {
      final matchesSearch =
          keyword.trim().isEmpty ||
          event.title.toLowerCase().contains(keyword) ||
          event.location.toLowerCase().contains(keyword) ||
          event.description.toLowerCase().contains(keyword);
      final matchesFilter = switch (filter) {
        EventCatalog.filterUpcoming => event.startDate.isAfter(now),
        EventCatalog.filterActive =>
          event.startDate.isBefore(now) && event.endDate.isAfter(now),
        EventCatalog.filterClosed => event.endDate.isBefore(now),
        EventCatalog.filterRegistrationOpen =>
          event.registrationDeadline.isAfter(now) && event.endDate.isAfter(now),
        _ => true,
      };
      return matchesSearch && matchesFilter;
    }).toList();

    return EventSort.sorted(filtered, sort: sort, at: now);
  }

  List<HackathonEvent> get visibleFilteredEvents =>
      filteredEvents.take(_visibleCount).toList();

  bool get hasMoreEvents => filteredEvents.length > _visibleCount;

  void loadMoreEvents() {
    if (!hasMoreEvents) return;
    _visibleCount += pageSize;
    notifyListeners();
  }

  void _resetVisibleCount() {
    _visibleCount = pageSize;
  }

  HackathonEvent byId(String id) =>
      events.firstWhere((event) => event.id == id);

  HackathonEvent? byIdOrNull(String id) {
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  Future<void> loadEvents() async {
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      events = EventSort.sorted(
        await _service.fetchEvents(),
        sort: sort,
      );
      _resetVisibleCount();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> saveEvent(
    HackathonEvent event, {
    String? existingEventId,
  }) async {
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    final validationError = AppValidators.eventPayload(
      title: event.title,
      location: event.location,
      bannerUrl: event.bannerUrl,
      startDate: event.startDate,
      endDate: event.endDate,
      registrationDeadline: event.registrationDeadline,
      maxTeamSize: event.maxTeamSize,
      latitude: event.latitude,
      longitude: event.longitude,
      submissionDeadline: event.submissionDeadline,
    );
    if (validationError != null) {
      error = validationError;
      isLoading = false;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      isLoading = false;
      notifyListeners();
      return;
    }
    try {
      await _service.saveEvent(event, existingEventId: existingEventId);
      await loadEvents();
      message = existingEventId == null
          ? L10nService.strings.eventCreatedSuccess
          : L10nService.strings.eventUpdatedSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    final queryError = AppValidators.eventSearchQuery(value);
    searchError = queryError;
    search = queryError == null
        ? value
        : value.substring(0, AppValidators.maxEventSearchLength);
    _resetVisibleCount();
    notifyListeners();
  }

  void updateFilter(String value) {
    filter = value;
    _resetVisibleCount();
    notifyListeners();
  }

  void updateSort(String value) {
    sort = value;
    events = EventSort.sorted(events, sort: sort);
    _resetVisibleCount();
    notifyListeners();
  }

  void resetFilters() {
    search = '';
    filter = EventCatalog.filterAll;
    sort = EventCatalog.sortStartAsc;
    searchError = null;
    _resetVisibleCount();
    notifyListeners();
  }

  void clear() {
    events = [];
    search = '';
    filter = EventCatalog.filterAll;
    sort = EventCatalog.sortStartAsc;
    message = null;
    error = null;
    searchError = null;
    isLoading = false;
    _resetVisibleCount();
    notifyListeners();
  }
}
