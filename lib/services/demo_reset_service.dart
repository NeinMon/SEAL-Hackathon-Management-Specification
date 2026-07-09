import '../core/app_helpers.dart';
import '../core/supabase_config.dart';

class DemoResetService {
  const DemoResetService();

  Future<void> resetDemoData() {
    AppLogger.action('demo.reset', {});
    return AppOperation.run('demo.reset', () {
      return SupabaseGateway.client.rpc('organizer_reset_demo');
    });
  }
}
