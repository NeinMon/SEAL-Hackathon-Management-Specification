import 'package:flutter/material.dart';

import 'app.dart';
import 'core/supabase_config.dart';

import 'services/push_notification_service.dart';

export 'app.dart';
export 'shared.dart';
export 'features/shell/app_shell.dart';
export 'features/auth/screens/login_screen.dart';
export 'features/chat/screens/chat_screen.dart';
export 'features/events/screens/event_detail_screen.dart';
export 'features/events/screens/event_list_screen.dart';
export 'features/judge/screens/judge_screen.dart';
export 'features/map/screens/map_screen.dart';
export 'features/notifications/screens/notification_screen.dart';
export 'features/organizer/screens/organizer_dashboard_screen.dart';
export 'features/profile/screens/profile_screen.dart';
export 'features/submissions/screens/submission_screen.dart';
export 'features/teams/screens/team_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.isConfigured) {
    await SupabaseGateway.initialize();
  }
  await PushNotificationService.instance.initialize();
  runApp(const SealApp());
}
