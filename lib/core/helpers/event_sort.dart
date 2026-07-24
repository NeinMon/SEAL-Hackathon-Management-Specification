import '../../models/hackathon_event.dart';
import 'event_catalog.dart';

class EventSort {
  EventSort._();

  /// Lower priority values are listed first.
  /// 0 = registration still open, 1 = ongoing but registration closed,
  /// 2 = not ended yet but inactive, 3 = ended.
  static int listingPriority(HackathonEvent event, [DateTime? at]) {
    final now = at ?? DateTime.now();
    if (event.endDate.isBefore(now)) return 3;
    if (event.registrationOpen(now)) return 0;
    if (event.submissionOpen(now) || event.judgingOpen(now)) return 1;
    return 2;
  }

  static int compare(
    HackathonEvent a,
    HackathonEvent b, {
    required String sort,
    DateTime? at,
  }) {
    final priority = listingPriority(a, at).compareTo(listingPriority(b, at));
    if (priority != 0) return priority;
    return _compareBySortKey(a, b, sort);
  }

  static List<HackathonEvent> sorted(
    List<HackathonEvent> source, {
    String sort = EventCatalog.sortStartAsc,
    DateTime? at,
  }) {
    final copy = [...source];
    copy.sort((a, b) => compare(a, b, sort: sort, at: at));
    return copy;
  }

  static int _compareBySortKey(
    HackathonEvent a,
    HackathonEvent b,
    String sort,
  ) {
    return switch (sort) {
      EventCatalog.sortStartDesc => b.startDate.compareTo(a.startDate),
      EventCatalog.sortTitleAsc => a.title.toLowerCase().compareTo(
        b.title.toLowerCase(),
      ),
      EventCatalog.sortTitleDesc => b.title.toLowerCase().compareTo(
        a.title.toLowerCase(),
      ),
      EventCatalog.sortDeadlineAsc => a.registrationDeadline.compareTo(
        b.registrationDeadline,
      ),
      EventCatalog.sortDeadlineDesc => b.registrationDeadline.compareTo(
        a.registrationDeadline,
      ),
      EventCatalog.sortStartAsc || _ => a.startDate.compareTo(b.startDate),
    };
  }
}
