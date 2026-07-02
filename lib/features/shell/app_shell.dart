import '../../shared.dart';
import 'widgets/notification_bell_button.dart';

const _showDemoOnboarding = bool.fromEnvironment(
  'SHOW_DEMO_ONBOARDING',
  defaultValue: false,
);

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
  String? _lastShownScoreAlertId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.read<AuthProvider>().user?.id;
    if (userId != null && userId != _watchedUserId) {
      _watchedUserId = userId;
      context.read<NotificationProvider>().watchForUser(userId);
    }
    final onboarding = context.read<OnboardingProvider>();
    if (_showDemoOnboarding &&
        userId != null &&
        onboarding.shouldShow &&
        !_onboardingPrompted) {
      _onboardingPrompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        DemoOnboardingDialog.show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const SessionRequired();
    }
    final role = auth.user?.role ?? 'guest';
    final items = _navigationItemsFor(role);
    final path = GoRouterState.of(context).uri.path;
    final selectedIndex = path.startsWith(AppRoutes.notifications)
        ? _lastBottomNavIndex
        : _selectedIndex(path, items);
    final notifications = context.watch<NotificationProvider>();
    final unreadCount = notifications.unreadCount;
    _maybeShowScoreSnackBar(notifications);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: HackCommandTopBar(
          subtitle: auth.user == null ? null : AppRoles.label(auth.user!.role),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationBellButton(
                unreadCount: unreadCount,
                highlight: notifications.bellHighlight,
                onPressed: () {
                  context.read<NotificationProvider>().clearScoreAlert();
                  context.go(AppRoutes.notifications);
                },
              ),
              PopupMenuButton<String>(
                tooltip: AppStrings.accountMenuTooltip,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'profile') {
                    context.go(AppRoutes.profile);
                    return;
                  }
                  if (value != 'logout') return;
                  final auth = context.read<AuthProvider>();
                  if (auth.user == null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.notLoggedInMessage),
                      ),
                    );
                    context.go(AppRoutes.login);
                    return;
                  }
                  context.read<EventProvider>().clear();
                  context.read<TeamProvider>().clear();
                  context.read<SubmissionProvider>().clear();
                  context.read<ScoreProvider>().clear();
                  context.read<NotificationProvider>().clear();
                  context.read<ChatProvider>().clear();
                  final loggedOut = await auth.logout();
                  if (!context.mounted) return;
                  if (!loggedOut) {
                    final message =
                        auth.error ?? AppStrings.logoutFailedMessage;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                    return;
                  }
                  context.go(AppRoutes.login);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(AppStrings.profileNavLabel),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(AppStrings.logoutButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: context.sealBackgroundGradient),
        child: SafeArea(top: false, child: widget.child),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          height: 72,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _lastBottomNavIndex = index);
            context.go(items[index].path);
          },
          destinations: [
            for (final item in items)
              NavigationDestination(icon: Icon(item.icon), label: item.label),
          ],
        ),
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
            content: const Text(AppStrings.newScoreSnackBar),
            action: SnackBarAction(
              label: AppStrings.openInboxAction,
              onPressed: () {
                context.read<NotificationProvider>().clearScoreAlert();
                context.go(AppRoutes.notifications);
              },
            ),
          ),
        );
    });
  }

  int _selectedIndex(String path, List<RoleNavigationItem> items) {
    if (path.startsWith(AppRoutes.notifications)) {
      final notificationsIndex = items.indexWhere(
        (item) => item.path == AppRoutes.notifications,
      );
      if (notificationsIndex != -1) return notificationsIndex;
    }
    final exact = items.indexWhere((item) {
      return path == item.path || path.startsWith('${item.path}/');
    });
    if (exact != -1) {
      return exact;
    }
    return _lastBottomNavIndex;
  }

  List<RoleNavigationItem> _navigationItemsFor(String role) {
    switch (role) {
      case 'judge':
        return const [
          RoleNavigationItem(
            AppStrings.eventsNavLabel,
            Icons.event_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            AppStrings.judgeNavLabel,
            Icons.rate_review_outlined,
            AppRoutes.judge,
          ),
          RoleNavigationItem(
            AppStrings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'mentor':
        return const [
          RoleNavigationItem(
            AppStrings.eventsNavLabel,
            Icons.event_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            AppStrings.teamNavLabel,
            Icons.groups_outlined,
            AppRoutes.teams,
          ),
          RoleNavigationItem(
            AppStrings.chatNavLabel,
            Icons.chat_outlined,
            AppRoutes.chat,
          ),
          RoleNavigationItem(
            AppStrings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'organizer':
        return const [
          RoleNavigationItem(
            AppStrings.dashboardNavLabel,
            Icons.dashboard_customize_outlined,
            AppRoutes.organizer,
          ),
          RoleNavigationItem(
            AppStrings.teamNavLabel,
            Icons.groups_outlined,
            AppRoutes.teams,
          ),
          RoleNavigationItem(
            AppStrings.judgeNavLabel,
            Icons.rate_review_outlined,
            AppRoutes.judge,
          ),
          RoleNavigationItem(
            AppStrings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'participant':
      default:
        return const [
          RoleNavigationItem(
            AppStrings.eventsNavLabel,
            Icons.event_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            AppStrings.teamNavLabel,
            Icons.groups_outlined,
            AppRoutes.teams,
          ),
          RoleNavigationItem(
            AppStrings.submitNavLabel,
            Icons.upload_file_outlined,
            AppRoutes.submit,
          ),
          RoleNavigationItem(
            AppStrings.chatNavLabel,
            Icons.chat_outlined,
            AppRoutes.chat,
          ),
          RoleNavigationItem(
            AppStrings.mapNavLabel,
            Icons.map_outlined,
            AppRoutes.map,
          ),
        ];
    }
  }
}

class RoleNavigationItem {
  const RoleNavigationItem(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}
