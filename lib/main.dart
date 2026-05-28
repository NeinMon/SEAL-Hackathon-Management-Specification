import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'core/supabase_config.dart';
part 'models/app_user.dart';
part 'models/hackathon_event.dart';
part 'models/team.dart';
part 'models/project_submission.dart';
part 'models/project_score.dart';
part 'models/app_notification.dart';
part 'models/chat_message.dart';
part 'services/supabase_services.dart';
part 'providers/auth_provider.dart';
part 'providers/event_provider.dart';
part 'providers/team_provider.dart';
part 'providers/submission_provider.dart';
part 'providers/score_provider.dart';
part 'providers/notification_provider.dart';
part 'providers/chat_provider.dart';
part 'views/app_shell.dart';
part 'views/auth/login_screen.dart';
part 'views/events/event_list_screen.dart';
part 'views/events/event_detail_screen.dart';
part 'views/teams/team_screen.dart';
part 'views/submissions/submission_screen.dart';
part 'views/judge/judge_screen.dart';
part 'views/notifications/notification_screen.dart';
part 'views/chat/chat_screen.dart';
part 'views/map/map_screen.dart';
part 'views/profile/profile_screen.dart';
part 'widgets/common_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }
  runApp(const SealApp());
}

class SealApp extends StatelessWidget {
  const SealApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return MaterialApp(
        title: 'SEAL Hackathon',
        debugShowCheckedModeBanner: false,
        theme: _buildSealTheme(),
        home: const SupabaseRequiredScreen(),
      );
    }

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/events',
              builder: (context, state) => const EventListScreen(),
            ),
            GoRoute(
              path: '/events/:id',
              builder: (context, state) =>
                  EventDetailScreen(eventId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: '/teams',
              builder: (context, state) => const TeamScreen(),
            ),
            GoRoute(
              path: '/submit',
              builder: (context, state) => const SubmissionScreen(),
            ),
            GoRoute(
              path: '/judge',
              builder: (context, state) => const JudgeScreen(),
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationScreen(),
            ),
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatScreen(),
            ),
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );

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
        routerConfig: router,
        theme: _buildSealTheme(),
      ),
    );
  }

  ThemeData _buildSealTheme() {
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
        backgroundColor: SealPalette.surfaceContainer,
        indicatorColor: SealPalette.primaryContainer,
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
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: SealPalette.outlineVariant),
          ).let(
            (border) => InputDecorationTheme(
              filled: true,
              fillColor: SealPalette.surfaceContainerLowest,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SealPalette.primary,
          side: const BorderSide(color: SealPalette.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
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
}

extension _InputBorderLet on OutlineInputBorder {
  T let<T>(T Function(OutlineInputBorder border) builder) => builder(this);
}
