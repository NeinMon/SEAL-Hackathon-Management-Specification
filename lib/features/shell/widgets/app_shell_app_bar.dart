import '../../../shared.dart';
import '../widgets/notification_bell_button.dart';

class AppShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppShellAppBar({
    super.key,
    required this.roleLabel,
    required this.unreadCount,
    required this.bellHighlight,
    required this.onProfile,
    required this.onNotifications,
    required this.onLogout,
  });

  final String roleLabel;
  final int unreadCount;
  final bool bellHighlight;
  final VoidCallback onProfile;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppSizes.appBarHeight,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: HackCommandTopBar(
        subtitle: roleLabel,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: context.l10n.profileNavLabel,
              onPressed: onProfile,
              icon: const Icon(Icons.person_outline),
            ),
            NotificationBellButton(
              unreadCount: unreadCount,
              highlight: bellHighlight,
              onPressed: onNotifications,
            ),
            PopupMenuButton<String>(
              tooltip: context.l10n.accountMenuTooltip,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'profile') {
                  onProfile();
                } else if (value == 'logout') {
                  onLogout();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(context.l10n.profileNavLabel),
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(context.l10n.logoutButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
