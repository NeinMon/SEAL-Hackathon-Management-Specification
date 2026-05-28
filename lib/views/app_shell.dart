part of '../main.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: HackCommandTopBar(
          subtitle: auth.user?.role.toUpperCase(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => context.go('/notifications'),
                icon: const Icon(Icons.notifications_outlined),
              ),
              PopupMenuButton<String>(
                tooltip: 'Account',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'profile') {
                    context.go('/profile');
                    return;
                  }
                  if (value != 'logout') return;
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  context.go('/login');
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Profile'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
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
      bottomNavigationBar: NavigationBar(
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
          RoleNavigationItem('Events', Icons.event_outlined, '/events'),
          RoleNavigationItem('Judge', Icons.rate_review_outlined, '/judge'),
          RoleNavigationItem(
            'Alerts',
            Icons.notifications_outlined,
            '/notifications',
          ),
        ];
      case 'mentor':
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, '/events'),
          RoleNavigationItem('Teams', Icons.groups_outlined, '/teams'),
          RoleNavigationItem('Chat', Icons.chat_outlined, '/chat'),
          RoleNavigationItem(
            'Alerts',
            Icons.notifications_outlined,
            '/notifications',
          ),
        ];
      case 'organizer':
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, '/events'),
          RoleNavigationItem('Teams', Icons.groups_outlined, '/teams'),
          RoleNavigationItem('Judge', Icons.rate_review_outlined, '/judge'),
          RoleNavigationItem(
            'Alerts',
            Icons.notifications_outlined,
            '/notifications',
          ),
        ];
      case 'participant':
      default:
        return const [
          RoleNavigationItem('Events', Icons.event_outlined, '/events'),
          RoleNavigationItem('Teams', Icons.groups_outlined, '/teams'),
          RoleNavigationItem('Submit', Icons.upload_file_outlined, '/submit'),
          RoleNavigationItem('Chat', Icons.chat_outlined, '/chat'),
          RoleNavigationItem('Map', Icons.map_outlined, '/map'),
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
