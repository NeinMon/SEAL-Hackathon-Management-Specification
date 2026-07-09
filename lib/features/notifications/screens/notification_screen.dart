import '../../../shared.dart';
import '../widgets/notification_screen_body.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<NotificationProvider>().watchForUser(
          user.id,
          role: user.role,
        );
        context.read<NotificationProvider>().clearScoreAlert();
      }
    });
  }

  Future<void> _refresh(String userId) async {
    await context.read<NotificationProvider>().loadForUser(userId);
  }

  NotificationViewState _resolveState(NotificationProvider provider) {
    if (provider.error != null && provider.notifications.isEmpty) {
      return NotificationViewState.error;
    }
    if (provider.isLoading && provider.notifications.isEmpty) {
      return NotificationViewState.loading;
    }
    if (provider.notifications.isEmpty) {
      return NotificationViewState.empty;
    }
    return NotificationViewState.content;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final user = context.watch<AuthProvider>().user;

    return NotificationScreenBody(
      state: _resolveState(provider),
      provider: provider,
      user: user,
      onRefresh: user == null ? () async {} : () => _refresh(user.id),
      onRetryWatch: user == null
          ? () {}
          : () => provider.watchForUser(user.id, role: user.role),
    );
  }
}
