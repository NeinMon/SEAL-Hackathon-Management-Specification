import 'shared.dart';
import 'views/app_shell.dart';
import 'views/auth/login_screen.dart';
import 'views/chat/chat_screen.dart';
import 'views/events/event_detail_screen.dart';
import 'views/events/event_list_screen.dart';
import 'views/judge/judge_screen.dart';
import 'views/map/map_screen.dart';
import 'views/notifications/notification_screen.dart';
import 'views/organizer/organizer_dashboard_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/submissions/submission_screen.dart';
import 'views/teams/team_screen.dart';

class SealApp extends StatelessWidget {
  const SealApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return MaterialApp(
        title: 'SEAL Hackathon',
        debugShowCheckedModeBanner: false,
        theme: buildSealTheme(),
        home: const SupabaseRequiredScreen(),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => SubmissionProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: 'SEAL Hackathon',
        debugShowCheckedModeBanner: false,
        routerConfig: buildSealRouter(),
        theme: buildSealTheme(),
      ),
    );
  }
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

ThemeData buildSealTheme() {
  const colors = ColorScheme.dark(
    primary: SealPalette.primary,
    onPrimary: SealPalette.onPrimary,
    primaryContainer: SealPalette.primaryContainer,
    onPrimaryContainer: SealPalette.onPrimaryContainer,
    secondary: SealPalette.secondary,
    onSecondary: SealPalette.onSecondary,
    surface: SealPalette.surface,
    onSurface: SealPalette.onSurface,
    error: SealPalette.error,
    errorContainer: SealPalette.errorContainer,
    onErrorContainer: SealPalette.onErrorContainer,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colors,
    scaffoldBackgroundColor: SealPalette.background,
    canvasColor: SealPalette.background,
    dividerColor: SealPalette.outlineVariant,
    appBarTheme: const AppBarTheme(
      backgroundColor: SealPalette.surfaceContainerLow,
      foregroundColor: SealPalette.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: SealPalette.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SealPalette.surfaceContainerLow,
      indicatorColor: SealPalette.primary.withValues(alpha: 0.16),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? SealPalette.primary
              : SealPalette.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? SealPalette.primary
              : SealPalette.onSurfaceVariant,
        ),
      ),
    ),
    inputDecorationTheme:
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SealPalette.outlineVariant),
        ).let(
          (border) => InputDecorationTheme(
            filled: true,
            fillColor: SealPalette.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            labelStyle: const TextStyle(color: SealPalette.onSurfaceVariant),
            hintStyle: const TextStyle(color: SealPalette.onSurfaceVariant),
            prefixIconColor: SealPalette.onSurfaceVariant,
            suffixIconColor: SealPalette.onSurfaceVariant,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(
                color: SealPalette.primary,
                width: 2,
              ),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: SealPalette.error),
            ),
          ),
        ),
    cardTheme: const CardThemeData(
      color: SealPalette.glassPanel,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: SealPalette.outlineVariant),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: SealPalette.surfaceContainerHigh,
      selectedColor: SealPalette.primaryContainer,
      side: const BorderSide(color: SealPalette.outlineVariant),
      labelStyle: const TextStyle(
        color: SealPalette.onSurface,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SealPalette.primaryContainer,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SealPalette.primary,
        side: const BorderSide(color: SealPalette.outlineVariant),
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: SealPalette.surfaceContainerHighest,
      contentTextStyle: const TextStyle(color: SealPalette.onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SealPalette.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: SealPalette.onSurface,
      displayColor: SealPalette.onSurface,
    ),
  );
}

extension _InputBorderLet on OutlineInputBorder {
  T let<T>(T Function(OutlineInputBorder border) builder) => builder(this);
}
