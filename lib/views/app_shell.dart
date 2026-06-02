import '../shared.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const SessionRequired();
    }
    final role = auth.user?.role ?? 'guest';
    final items = _navigationItemsFor(role);
    final path = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(path, items);
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
              IconButton(
                tooltip: 'Thông báo',
                onPressed: () => context.go(AppRoutes.notifications),
                icon: const Icon(Icons.notifications_outlined),
              ),
              PopupMenuButton<String>(
                tooltip: 'Tài khoản',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'profile') {
                    context.go(AppRoutes.profile);
                    return;
                  }
                  if (value != 'logout') return;
                  context.read<EventProvider>().clear();
                  context.read<TeamProvider>().clear();
                  context.read<SubmissionProvider>().clear();
                  context.read<ScoreProvider>().clear();
                  context.read<NotificationProvider>().clear();
                  context.read<ChatProvider>().clear();
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Hồ sơ'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Đăng xuất'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SealPalette.background,
              SealPalette.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(top: false, child: child),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          height: 72,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
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

  int _selectedIndex(String path, List<RoleNavigationItem> items) {
    final exact = items.indexWhere((item) => path.startsWith(item.path));
    if (exact != -1) return exact;
    return 0;
  }

  List<RoleNavigationItem> _navigationItemsFor(String role) {
    switch (role) {
      case 'judge':
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, AppRoutes.events),
          RoleNavigationItem(
            'Chấm điểm',
            Icons.rate_review_outlined,
            AppRoutes.judge,
          ),
          RoleNavigationItem(
            'Thông báo',
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'mentor':
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, AppRoutes.events),
          RoleNavigationItem('Team', Icons.groups_outlined, AppRoutes.teams),
          RoleNavigationItem('Chat', Icons.chat_outlined, AppRoutes.chat),
          RoleNavigationItem(
            'Thông báo',
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'organizer':
        return const [
          RoleNavigationItem(
            'Dashboard',
            Icons.dashboard_customize_outlined,
            AppRoutes.organizer,
          ),
          RoleNavigationItem('Team', Icons.groups_outlined, AppRoutes.teams),
          RoleNavigationItem(
            'Chấm điểm',
            Icons.rate_review_outlined,
            AppRoutes.judge,
          ),
          RoleNavigationItem(
            'Thông báo',
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'participant':
      default:
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, AppRoutes.events),
          RoleNavigationItem('Team', Icons.groups_outlined, AppRoutes.teams),
          RoleNavigationItem(
            'Nộp bài',
            Icons.upload_file_outlined,
            AppRoutes.submit,
          ),
          RoleNavigationItem('Chat', Icons.chat_outlined, AppRoutes.chat),
          RoleNavigationItem('Bản đồ', Icons.map_outlined, AppRoutes.map),
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
