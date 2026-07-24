import 'core/auth_deep_link.dart';
import 'shared.dart';
import 'features/shell/screens/app_shell.dart';
import 'features/shell/screens/event_shell.dart';
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
        title: 'SEAL Hackathon',
        debugShowCheckedModeBanner: false,
        theme: buildSealTheme(brightness: Brightness.dark),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: const SupabaseRequiredScreen(),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()..load()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => OrganizerDashboardUiProvider()),
        ChangeNotifierProvider(create: (_) => ActiveEventProvider()),
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
    final locale = context.watch<LocaleProvider>();
    return MaterialApp.router(
      title: L10nService.strings.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: buildSealRouter(),
      theme: buildSealTheme(brightness: Brightness.light),
      darkTheme: buildSealTheme(brightness: Brightness.dark),
      themeMode: theme.mode,
      locale: locale.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
        onAuthenticated: (event) async {
          if (!mounted) return;
          final auth = context.read<AuthProvider>();
          if (event.flow == AuthDeepLinkFlow.recovery) {
            if (event.error != null) {
              auth.showPasswordRecoveryLinkError();
              if (mounted) context.go(AppRoutes.login);
              return;
            }
            await auth.startPasswordRecovery();
            if (mounted) context.go(AppRoutes.login);
          } else if (event.flow == AuthDeepLinkFlow.signup) {
            auth.showSignupOtpRequiredMessage();
            if (mounted) context.go(AppRoutes.login);
          } else if (event.flow == AuthDeepLinkFlow.invite) {
            if (event.error != null) {
              auth.showInviteEmailMessage();
              if (mounted) context.go(AppRoutes.login);
              return;
            }
            final opened = await auth.refreshFromInviteDeepLink();
            if (!mounted) return;
            if (!opened || auth.user == null) {
              context.go(AppRoutes.login);
              return;
            }
            await context
                .read<TeamProvider>()
                .acceptLatestInvitationFromEmail(auth.user!);
            if (mounted) context.go(AppRoutes.teams);
          } else {
            auth.showSignupOtpRequiredMessage();
            if (mounted) context.go(AppRoutes.login);
          }
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
    redirect: (context, state) {
      if (state.uri.scheme == SupabaseConfig.authRedirectScheme &&
          state.uri.host == SupabaseConfig.authRedirectHost) {
        return AppRoutes.login;
      }
      final path = state.uri.path;
      final eventId = state.uri.queryParameters[RouteQuery.eventKey];
      if (eventId != null && eventId.isNotEmpty) {
        if (path == AppRoutes.teams) {
          return RouteQuery.teamsForEvent(eventId);
        }
        if (path == AppRoutes.map) {
          return RouteQuery.mapForEvent(eventId);
        }
        if (path == AppRoutes.judge) {
          return RouteQuery.judgeForEvent(eventId);
        }
      }
      final teamId = state.uri.queryParameters[RouteQuery.teamKey];
      if (teamId != null &&
          teamId.isNotEmpty &&
          path == AppRoutes.submit &&
          !RouteQuery.isEventScopedPath(path)) {
        try {
          final redirect = RouteQuery.redirectFlatSubmit(
            context.read<TeamProvider>().teams,
            teamId,
          );
          if (redirect != null) return redirect;
        } catch (_) {}
      }
      return null;
    },
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
            path: '/events/:eventId',
            redirect: (context, state) {
              if (state.uri.pathSegments.length == 2) {
                return RouteQuery.overviewForEvent(
                  state.pathParameters['eventId']!,
                );
              }
              return null;
            },
            routes: [
              ShellRoute(
                builder: (context, state, child) => EventShell(
                  eventId: state.pathParameters['eventId']!,
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: 'overview',
                    builder: (context, state) => EventDetailScreen(
                      eventId: state.pathParameters['eventId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'team',
                    builder: (context, state) => const TeamScreen(),
                  ),
                  GoRoute(
                    path: 'submit',
                    builder: (context, state) => const SubmissionScreen(),
                  ),
                  GoRoute(
                    path: 'chat',
                    builder: (context, state) => const ChatScreen(),
                  ),
                  GoRoute(
                    path: 'map',
                    builder: (context, state) => const MapScreen(),
                  ),
                  GoRoute(
                    path: 'judge',
                    builder: (context, state) => const JudgeScreen(),
                  ),
                ],
              ),
            ],
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
