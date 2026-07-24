import '../../../shared.dart';

class RoleNavigationItem {
  const RoleNavigationItem(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

class AppShellNavigation {
  AppShellNavigation._();

  static List<RoleNavigationItem> itemsFor(String role) {
    switch (role) {
      case 'judge':
        return [
          RoleNavigationItem(
            L10nService.strings.eventsNavLabel,
            Icons.event_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            L10nService.strings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'mentor':
        return [
          RoleNavigationItem(
            L10nService.strings.eventsNavLabel,
            Icons.event_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            L10nService.strings.chatNavLabel,
            Icons.chat_bubble_outline,
            AppRoutes.chat,
          ),
          RoleNavigationItem(
            L10nService.strings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'organizer':
        return [
          RoleNavigationItem(
            L10nService.strings.dashboardNavLabel,
            Icons.dashboard_customize_outlined,
            AppRoutes.organizer,
          ),
          RoleNavigationItem(
            L10nService.strings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
      case 'participant':
      default:
        return [
          RoleNavigationItem(
            L10nService.strings.myHomeNavLabel,
            Icons.home_outlined,
            AppRoutes.events,
          ),
          RoleNavigationItem(
            L10nService.strings.notificationsNavLabel,
            Icons.notifications_outlined,
            AppRoutes.notifications,
          ),
        ];
    }
  }

  static int selectedIndex({
    required String path,
    required List<RoleNavigationItem> items,
    required int lastBottomNavIndex,
  }) {
    if (path.startsWith(AppRoutes.notifications)) {
      final notificationsIndex = items.indexWhere(
        (item) => item.path == AppRoutes.notifications,
      );
      if (notificationsIndex != -1) return notificationsIndex;
    }
    final exact = items.indexWhere((item) {
      return path == item.path || path.startsWith('${item.path}/');
    });
    if (exact != -1) return exact;
    return lastBottomNavIndex;
  }

  static Widget navIcon(RoleNavigationItem item, int pendingInvites) {
    final icon = Icon(item.icon);
    if (item.path == AppRoutes.events && pendingInvites > 0) {
      return Badge(
        label: Text('$pendingInvites'),
        isLabelVisible: true,
        child: icon,
      );
    }
    return icon;
  }
}
