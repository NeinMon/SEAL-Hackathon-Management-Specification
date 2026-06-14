import 'package:flutter/material.dart';

import 'app.dart';
import 'core/supabase_config.dart';

export 'app.dart';
export 'shared.dart';
export 'views/app_shell.dart';
export 'features/auth/screens/login_screen.dart';
export 'features/chat/screens/chat_screen.dart';
export 'features/events/screens/event_detail_screen.dart';
export 'features/events/screens/event_list_screen.dart';
export 'views/judge/judge_screen.dart';
export 'views/map/map_screen.dart';
export 'features/notifications/screens/notification_screen.dart';
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


