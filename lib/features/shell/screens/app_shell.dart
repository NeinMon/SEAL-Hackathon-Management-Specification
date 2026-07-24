import '../../../shared.dart';
import '../helpers/app_shell_logout.dart';
import '../helpers/app_shell_navigation.dart';
import '../widgets/app_shell_app_bar.dart';
import '../widgets/app_shell_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _watchedUserId;
  int _lastBottomNavIndex = 0;
  bool _onboardingPrompted = false;
  bool _roleLandingHandled = false;
  String? _lastShownScoreAlertId;
  String? _lastRefreshedEventId;
  bool _refreshing = false;
  bool _shellSyncQueued = false;
  ActiveEventProvider? _activeEventProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _bindActiveEventListener(),
    );
  }

  void _bindActiveEventListener() {
    if (!mounted) return;
    _activeEventProvider?.removeListener(_onActiveEventChanged);
    _activeEventProvider = context.read<ActiveEventProvider>();
    _activeEventProvider!.addListener(_onActiveEventChanged);
  }

  @override
  void dispose() {
    _activeEventProvider?.removeListener(_onActiveEventChanged);
    super.dispose();
  }

  void _onActiveEventChanged() {
    final auth = context.read<AuthProvider>().user;
    if (auth == null || _refreshing) return;
    final eventId = context.read<ActiveEventProvider>().selectedEventId;
    if (eventId == _lastRefreshedEventId) return;
    unawaited(_refreshEventScopedData(auth, eventId));
  }

  Future<void> _refreshEventScopedData(AppUser user, String? eventId) async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      await Future.wait([
        context.read<EventProvider>().loadEvents(),
        context.read<TeamProvider>().loadTeamWorkspace(user),
        context.read<TeamProvider>().loadTeams(eventId: eventId),
        context.read<SubmissionProvider>().loadSubmissions(eventId: eventId),
        context.read<ScoreProvider>().loadScores(eventId: eventId),
      ]);
      _lastRefreshedEventId = eventId;
      if (!mounted) return;
      _syncActiveEvent();
      _maybeAutoNavigate(user);
    } finally {
      _refreshing = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotificationDeepLink.bind((route) {
      if (!mounted) return;
      context.go(route);
    });
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    final userId = user?.id;
    if (userId != null && userId != _watchedUserId) {
      _watchedUserId = userId;
      _onboardingPrompted = false;
      _roleLandingHandled = false;
      _lastRefreshedEventId = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final currentUser = context.read<AuthProvider>().user;
        if (currentUser == null || currentUser.id != userId) return;
        unawaited(_bootstrapUserSession(currentUser));
      });
    }
    _queueShellSync();
  }

  Future<void> _bootstrapUserSession(AppUser user) async {
    context.read<NotificationProvider>().watchForUser(user.id, role: user.role);
    await Future.wait([
      context.read<ActiveEventProvider>().loadForUser(user.id),
      context.read<OnboardingProvider>().loadForRole(user.role),
    ]);
    if (!mounted) return;
    _maybeShowOnboardingPrompt(user);
    await _refreshEventScopedData(user, null);
  }

  void _queueShellSync() {
    if (_shellSyncQueued) return;
    _shellSyncQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shellSyncQueued = false;
      if (!mounted) return;
      _syncActiveEvent();
      final user = context.read<AuthProvider>().user;
      if (user != null) _maybeShowOnboardingPrompt(user);
    });
  }

  void _maybeShowOnboardingPrompt(AppUser user) {
    final onboarding = context.read<OnboardingProvider>();
    if (!onboarding.shouldShow || _onboardingPrompted) return;
    _onboardingPrompted = true;
    RoleOnboardingDialog.show(context, user.role);
  }

  void _syncActiveEvent() {
    final auth = context.read<AuthProvider>().user;
    if (auth == null) return;
    final events = context.read<EventProvider>().events;
    final teams = context.read<TeamProvider>().teams;
    if (events.isEmpty) return;
    WorkspaceCatalog.bind(events: events, teams: teams);
    context.read<ActiveEventProvider>().syncContext(
      events: events,
      teams: teams,
      userId: auth.id,
      routeEventId: RouteQuery.eventIdFrom(context),
    );
    _maybeAutoNavigate(auth);
  }

  void _maybeAutoNavigate(AppUser user) {
    if (_roleLandingHandled) return;
    final path = GoRouterState.of(context).uri.path;
    if (path != AppRoutes.events) return;
    final events = context.read<EventProvider>().events;
    if (events.isEmpty) return;
    final active = context.read<ActiveEventProvider>();
    final route = RoleLanding.deepLinkAfterBootstrap(
      role: user.role,
      events: events,
      teams: context.read<TeamProvider>().teams,
      userId: user.id,
      storedEventId: active.selectedEventId,
    );
    if (route == null || route == path) return;
    _roleLandingHandled = true;
    context.go(route);
  }

  Future<void> _logout() async {
    _lastRefreshedEventId = null;
    await AppShellLogout.perform(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const SessionRequired();
    }
    final user = auth.user!;
    final items = AppShellNavigation.itemsFor(user.role);
    final path = GoRouterState.of(context).uri.path;
    final isEventScoped = RouteQuery.isEventScopedPath(path);
    final selectedIndex = AppShellNavigation.selectedIndex(
      path: path,
      items: items,
      lastBottomNavIndex: _lastBottomNavIndex,
    );
    final notifications = context.watch<NotificationProvider>();
    final teams = context.watch<TeamProvider>();
    final suppressBottomNav = context
        .watch<OrganizerDashboardUiProvider>()
        .suppressAppShellBottomNav;
    _maybeShowScoreSnackBar(notifications);

    return Scaffold(
      appBar: isEventScoped
          ? null
          : AppShellAppBar(
              roleLabel: AppRoles.label(user.role),
              unreadCount: notifications.unreadCount,
              bellHighlight: notifications.bellHighlight,
              onProfile: () => context.go(AppRoutes.profile),
              onNotifications: () {
                context.read<NotificationProvider>().clearScoreAlert();
                context.go(AppRoutes.notifications);
              },
              onLogout: () => unawaited(_logout()),
            ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: context.sealBackgroundGradient),
        child: SafeArea(top: false, child: widget.child),
      ),
      bottomNavigationBar: isEventScoped || suppressBottomNav
          ? null
          : AppShellBottomNav(
              items: items,
              selectedIndex: selectedIndex,
              pendingInvites: teams.pendingInvitationCountFor(user.id),
              onDestinationSelected: (index) {
                setState(() => _lastBottomNavIndex = index);
                context.go(items[index].path);
              },
            ),
    );
  }

  void _maybeShowScoreSnackBar(NotificationProvider notifications) {
    final alert = notifications.pendingScoreAlert;
    if (alert == null || alert.id == _lastShownScoreAlertId) return;
    _lastShownScoreAlertId = alert.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.newScoreSnackBar),
            action: SnackBarAction(
              label: L10nService.strings.openInboxAction,
              onPressed: () {
                context.read<NotificationProvider>().clearScoreAlert();
                context.go(AppRoutes.notifications);
              },
            ),
          ),
        );
    });
  }
}
