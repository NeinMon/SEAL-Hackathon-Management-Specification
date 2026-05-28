part of '../main.dart';

class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

class SupabaseGateway {
  SupabaseGateway._();

  static bool get enabled => SupabaseConfig.isConfigured;
  static SupabaseClient get client => Supabase.instance.client;
}
