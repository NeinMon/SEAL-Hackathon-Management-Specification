import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const local = 'local';
  static const staging = 'staging';
  static const production = 'production';

  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: local,
  );
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
  static bool get isProduction => environment == production;
  static bool get isStaging => environment == staging;
  static bool get isLocal => environment == local;
  static bool get isKnownEnvironment => isLocal || isStaging || isProduction;

  static const authRedirectScheme = 'vn.seal.hackathon';
  static const authRedirectHost = 'auth-callback';
  static const authRedirectUrl = '$authRedirectScheme://$authRedirectHost';

  /// Mailpit port is API port + 3 in local `supabase/config.toml`.
  static String get localMailpitUrl {
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasPort) {
      return 'http://127.0.0.1:${parsed.port + 3}';
    }
    return 'http://127.0.0.1:55324';
  }

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

  static bool get isReady => enabled && _client != null;

  static Future<void> initialize() async {
    if (!SupabaseConfig.isConfigured || _client != null) return;
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client {
    final current = _client;
    if (current == null) {
      throw StateError('SupabaseGateway is not configured.');
    }
    return current;
  }
}
