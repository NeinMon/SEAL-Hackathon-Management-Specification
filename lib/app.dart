import 'core/auth_deep_link.dart';
import 'shared.dart';
import 'features/shell/app_shell.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/events/screens/event_detail_screen.dart';
import 'features/events/screens/event_list_screen.dart';
import 'features/judge/screens/judge_screen.dart';
import 'features/map/screens/map_screen.dart';
import 'features/notifications/screens/notification_screen.dart';
import 'features/organizer/screens/organizer_dashboard_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/submissions/screens/submission_screen.dart';
import 'features/teams/screens/team_screen.dart';

class SealApp extends StatelessWidget {
  const SealApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: buildSealTheme(brightness: Brightness.dark),
        home: const SupabaseRequiredScreen(),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..load()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => SubmissionProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const _AuthDeepLinkScope(child: _SealRouterApp()),
    );
  }
}

class _SealRouterApp extends StatelessWidget {
  const _SealRouterApp();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: buildSealRouter(),
      theme: buildSealTheme(brightness: Brightness.light),
      darkTheme: buildSealTheme(brightness: Brightness.dark),
      themeMode: theme.mode,
    );
  }
}

class _AuthDeepLinkScope extends StatefulWidget {
  const _AuthDeepLinkScope({required this.child});

  final Widget child;

  @override
  State<_AuthDeepLinkScope> createState() => _AuthDeepLinkScopeState();
}

class _AuthDeepLinkScopeState extends State<_AuthDeepLinkScope> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !SupabaseGateway.isReady) return;
      await AuthDeepLinkHandler.setup(
        onAuthenticated: () async {
          if (!mounted) return;
          await context.read<AuthProvider>().refreshFromDeepLink();
        },
      );
    });
  }

  @override
  void dispose() {
    AuthDeepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

GoRouter buildSealRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.events,
            builder: (context, state) => const EventListScreen(),
          ),
          GoRoute(
            path: '/events/:id',
            builder: (context, state) =>
                EventDetailScreen(eventId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: AppRoutes.teams,
            builder: (context, state) => const TeamScreen(),
          ),
          GoRoute(
            path: AppRoutes.submit,
            builder: (context, state) => const SubmissionScreen(),
          ),
          GoRoute(
            path: AppRoutes.judge,
            builder: (context, state) => const JudgeScreen(),
          ),
          GoRoute(
            path: AppRoutes.organizer,
            builder: (context, state) => const OrganizerDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => const NotificationScreen(),
          ),
          GoRoute(
            path: AppRoutes.chat,
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: AppRoutes.map,
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
