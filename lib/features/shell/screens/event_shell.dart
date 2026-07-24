import '../../../shared.dart';
import '../widgets/notification_bell_button.dart';

class _EventShellTab {
  const _EventShellTab(this.route, this.icon, this.label);

  final String Function(String eventId) route;
  final IconData icon;
  final String label;
}

class EventShell extends StatefulWidget {
  const EventShell({super.key, required this.eventId, required this.child});

  final String eventId;
  final Widget child;

  @override
  State<EventShell> createState() => _EventShellState();
}

class _EventShellState extends State<EventShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveEventProvider>().setFromUserPick(widget.eventId);
    });
  }

  List<_EventShellTab> _tabsForRole(String? role) {
    switch (role) {
      case AppRoles.judge:
        return [
          _EventShellTab(
            RouteQuery.overviewForEvent,
            Icons.dashboard_outlined,
            L10nService.strings.eventSubNavOverview,
          ),
          _EventShellTab(
            RouteQuery.judgeForEvent,
            Icons.rate_review_outlined,
            L10nService.strings.judgeNavLabel,
          ),
        ];
      case AppRoles.mentor:
        return [
          _EventShellTab(
            RouteQuery.overviewForEvent,
            Icons.dashboard_outlined,
            L10nService.strings.eventSubNavOverview,
          ),
          _EventShellTab(
            RouteQuery.chatForEvent,
            Icons.chat_outlined,
            L10nService.strings.chatNavLabel,
          ),
        ];
      default:
        return [
          _EventShellTab(
            RouteQuery.overviewForEvent,
            Icons.dashboard_outlined,
            L10nService.strings.eventSubNavOverview,
          ),
          _EventShellTab(
            RouteQuery.teamsForEvent,
            Icons.groups_outlined,
            L10nService.strings.teamNavLabel,
          ),
          _EventShellTab(
            RouteQuery.submitForEvent,
            Icons.upload_file_outlined,
            L10nService.strings.submitNavLabel,
          ),
          _EventShellTab(
            RouteQuery.chatForEvent,
            Icons.chat_outlined,
            L10nService.strings.chatNavLabel,
          ),
          _EventShellTab(
            RouteQuery.mapForEvent,
            Icons.map_outlined,
            L10nService.strings.mapNavLabel,
          ),
        ];
    }
  }

  int _selectedIndex(String path, List<_EventShellTab> tabs) {
    for (var index = 0; index < tabs.length; index++) {
      if (path == tabs[index].route(widget.eventId)) return index;
    }
    return 0;
  }

  String _tabLabel(BuildContext context, _EventShellTab tab) {
    final compact = MediaQuery.sizeOf(context).width < 380;
    if (!compact) return tab.label;
    if (tab.label == L10nService.strings.submitNavLabel) {
      return 'Nộp';
    }
    if (tab.label == L10nService.strings.eventSubNavOverview) {
      return 'Tổng quan';
    }
    return tab.label;
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();
    final event = events.byIdOrNull(widget.eventId);
    final path = GoRouterState.of(context).uri.path;
    final auth = context.watch<AuthProvider>().user;
    final role = auth?.role;
    final tabs = _tabsForRole(role);
    final selectedIndex = _selectedIndex(path, tabs);
    final backLabel = role == AppRoles.participant
        ? L10nService.strings.backToEventsAction
        : L10nService.strings.backToEventListAction;
    final pendingInvites = auth == null
        ? 0
        : context.watch<TeamProvider>().pendingInvitationCountFor(auth.id);
    final notifications = context.watch<NotificationProvider>();
    final unreadCount = notifications.unreadCount;

    return Column(
      children: [
        CompactShellHeader(
          onBack: () => context.go(AppRoutes.events),
          backTooltip: backLabel,
          title: event?.title ?? L10nService.strings.eventsTitle,
          trailing: [
            NotificationBellButton(
              unreadCount: unreadCount,
              highlight: notifications.bellHighlight,
              onPressed: () {
                context.read<NotificationProvider>().clearScoreAlert();
                context.go(AppRoutes.notifications);
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: context.l10n.profileNavLabel,
              onPressed: () => context.go(AppRoutes.profile),
              icon: Icon(Icons.person_outline),
            ),
          ],
        ),
        Expanded(child: widget.child),
        CompactShellNavBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              context.go(tabs[index].route(widget.eventId)),
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: tab.label == L10nService.strings.teamNavLabel &&
                        pendingInvites > 0
                    ? Badge(
                        label: Text('$pendingInvites'),
                        isLabelVisible: true,
                        child: Icon(tab.icon),
                      )
                    : Icon(tab.icon),
                label: _tabLabel(context, tab),
              ),
          ],
        ),
      ],
    );
  }
}
