import 'dart:async';

import 'package:app_links/app_links.dart';

import 'supabase_config.dart';

typedef AuthDeepLinkCallback = Future<void> Function();

class AuthDeepLinkHandler {
  AuthDeepLinkHandler._();

  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _subscription;
  static AuthDeepLinkCallback? _onAuthenticated;

  static Future<void> setup({AuthDeepLinkCallback? onAuthenticated}) async {
    if (!SupabaseGateway.isReady) return;
    _onAuthenticated = onAuthenticated;
    await _handleUri(await _appLinks.getInitialLink());
    await _subscription?.cancel();
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _onAuthenticated = null;
  }

  static Future<void> _handleUri(Uri? uri) async {
    if (uri == null || !SupabaseGateway.isReady) return;
    if (uri.scheme != SupabaseConfig.authRedirectScheme) return;
    if (uri.host != SupabaseConfig.authRedirectHost) return;
    try {
      await SupabaseGateway.client.auth.getSessionFromUrl(uri);
      await _onAuthenticated?.call();
    } catch (_) {
      // Login screen / auth provider surfaces errors from session restore.
    }
  }
}
