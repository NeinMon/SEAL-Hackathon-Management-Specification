import '../l10n/l10n_service.dart';

class EventCatalog {
  const EventCatalog._();

  static const sortStartAsc = 'start_asc';
  static const sortStartDesc = 'start_desc';
  static const sortTitleAsc = 'title_asc';
  static const sortTitleDesc = 'title_desc';
  static const sortDeadlineAsc = 'deadline_asc';
  static const sortDeadlineDesc = 'deadline_desc';

  static const filterAll = 'all';
  static const filterUpcoming = 'upcoming';
  static const filterActive = 'active';
  static const filterClosed = 'closed';
  static const filterRegistrationOpen = 'registration_open';

  static Map<String, String> get sortLabels => {
    sortStartAsc: L10nService.strings.sortStartAsc,
    sortStartDesc: L10nService.strings.sortStartDesc,
    sortTitleAsc: L10nService.strings.sortTitleAsc,
    sortTitleDesc: L10nService.strings.sortTitleDesc,
    sortDeadlineAsc: L10nService.strings.sortDeadlineAsc,
    sortDeadlineDesc: L10nService.strings.sortDeadlineDesc,
  };

  static Map<String, String> get filterLabels => {
    filterAll: L10nService.strings.allFilter,
    filterUpcoming: L10nService.strings.statusUpcoming,
    filterActive: L10nService.strings.statusActive,
    filterClosed: L10nService.strings.statusClosed,
    filterRegistrationOpen: L10nService.strings.filterRegistrationOpen,
  };
}
