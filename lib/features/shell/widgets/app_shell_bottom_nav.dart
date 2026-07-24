import '../../../shared.dart';
import '../helpers/app_shell_navigation.dart';

class AppShellBottomNav extends StatelessWidget {
  const AppShellBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.pendingInvites,
    required this.onDestinationSelected,
  });

  final List<RoleNavigationItem> items;
  final int selectedIndex;
  final int pendingInvites;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return CompactShellNavBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: AppShellNavigation.navIcon(item, pendingInvites),
            label: item.label,
          ),
      ],
    );
  }
}
