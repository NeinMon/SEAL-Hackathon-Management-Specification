part of '../main.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = const EventService();
  List<HackathonEvent> events = [];

  bool isLoading = false;
  String search = '';
  String filter = 'all';
  String? error;

  List<HackathonEvent> get filteredEvents {
    final keyword = search.toLowerCase();
    return events.where((event) {
      final matchesSearch =
          keyword.trim().isEmpty ||
          event.title.toLowerCase().contains(keyword) ||
          event.location.toLowerCase().contains(keyword) ||
          event.description.toLowerCase().contains(keyword);
      final now = DateTime.now();
      final matchesFilter =
          filter == 'all' ||
          (filter == 'upcoming' && event.startDate.isAfter(now)) ||
          (filter == 'active' &&
              event.startDate.isBefore(now) &&
              event.endDate.isAfter(now)) ||
          (filter == 'closed' && event.endDate.isBefore(now));
      return matchesSearch && matchesFilter;
    }).toList();
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
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      events = await _service.fetchEvents();
    } catch (exception) {
      error = exception.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    search = value;
    notifyListeners();
  }

  void updateFilter(String value) {
    filter = value;
    notifyListeners();
  }
}
