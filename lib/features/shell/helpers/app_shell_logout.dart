import '../../../shared.dart';

class AppShellLogout {
  AppShellLogout._();

  static Future<void> perform(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notLoggedInMessage)),
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
    context.read<ActiveEventProvider>().clear();
    context.read<OnboardingProvider>().clear();
    final loggedOut = await auth.logout();
    if (!context.mounted) return;
    if (!loggedOut) {
      final message = auth.error ?? L10nService.strings.logoutFailedMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }
    context.go(AppRoutes.login);
  }
}
