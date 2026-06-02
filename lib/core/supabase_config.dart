import 'package:supabase/supabase.dart';

class SupabaseConfig {
  static const local = 'local';
  static const staging = 'staging';
  static const production = 'production';

  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: local,
  );
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
  static bool get isProduction => environment == production;
  static bool get isStaging => environment == staging;
  static bool get isLocal => environment == local;
  static bool get isKnownEnvironment => isLocal || isStaging || isProduction;

  static String get displayName {
    if (isProduction) return 'Production';
    if (isStaging) return 'Staging';
    if (isLocal) return 'Local';
    return 'Custom';
  }
}

class SupabaseGateway {
  SupabaseGateway._();

  static SupabaseClient? _client;

  static bool get enabled => SupabaseConfig.isConfigured;

  static void initialize() {
    if (!SupabaseConfig.isConfigured) return;
    _client ??= SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);
  }

  static SupabaseClient get client {
    final current = _client;
    if (current == null) {
      throw StateError('SupabaseGateway is not configured.');
    }
    return current;
  }
}
