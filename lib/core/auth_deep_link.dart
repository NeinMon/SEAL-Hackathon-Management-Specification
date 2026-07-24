import 'dart:async';

import 'package:app_links/app_links.dart';

import 'supabase_config.dart';

enum AuthDeepLinkFlow { recovery, signup, invite, unknown }

class AuthDeepLinkEvent {
  const AuthDeepLinkEvent({required this.uri, required this.flow, this.error});

  final Uri uri;
  final AuthDeepLinkFlow flow;
  final Object? error;
}

typedef AuthDeepLinkCallback = Future<void> Function(AuthDeepLinkEvent event);

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
    final flow = _flowFor(uri);
    if (flow == AuthDeepLinkFlow.signup || flow == AuthDeepLinkFlow.unknown) {
      await _onAuthenticated?.call(AuthDeepLinkEvent(uri: uri, flow: flow));
      return;
    }
    try {
      await SupabaseGateway.client.auth.getSessionFromUrl(uri);
      await _onAuthenticated?.call(AuthDeepLinkEvent(uri: uri, flow: flow));
    } catch (error) {
      await _onAuthenticated?.call(
        AuthDeepLinkEvent(uri: uri, flow: flow, error: error),
      );
    }
  }

  static AuthDeepLinkFlow _flowFor(Uri uri) {
    final params = <String, String>{...uri.queryParameters};
    if (uri.fragment.isNotEmpty) {
      params.addAll(Uri.splitQueryString(uri.fragment));
    }
    for (final segment in uri.pathSegments) {
      switch (segment) {
        case 'recovery':
          return AuthDeepLinkFlow.recovery;
        case 'signup':
          return AuthDeepLinkFlow.signup;
        case 'invite':
          return AuthDeepLinkFlow.invite;
      }
    }
    switch (params['flow'] ?? params['type']) {
      case 'recovery':
        return AuthDeepLinkFlow.recovery;
      case 'signup':
        return AuthDeepLinkFlow.signup;
      case 'invite':
      case 'team_invitation':
      case 'magiclink':
        return AuthDeepLinkFlow.invite;
      default:
        if (params.containsKey('code')) {
          return AuthDeepLinkFlow.invite;
        }
        return AuthDeepLinkFlow.unknown;
    }
  }
}
