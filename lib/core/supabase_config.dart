part of '../main.dart';

class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
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
