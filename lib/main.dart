import 'package:flutter/material.dart';

import 'app.dart';
import 'core/supabase_config.dart';

export 'app.dart';
export 'shared.dart';
export 'views/app_shell.dart';
export 'features/auth/screens/login_screen.dart';
export 'views/chat/chat_screen.dart';
export 'views/events/event_detail_screen.dart';
export 'views/events/event_list_screen.dart';
export 'views/judge/judge_screen.dart';
export 'views/map/map_screen.dart';
export 'views/notifications/notification_screen.dart';
export 'views/organizer/organizer_dashboard_screen.dart';
export 'features/profile/screens/profile_screen.dart';
export 'views/submissions/submission_screen.dart';
export 'views/teams/team_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.isConfigured) {
    await SupabaseGateway.initialize();
  }
  runApp(const SealApp());
}

