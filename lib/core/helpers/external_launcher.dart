import 'package:flutter/services.dart';

class ExternalLauncher {
  const ExternalLauncher._();

  static const _channel = MethodChannel('vn.seal.hackathon/external');

  static Future<bool> openUrl(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return false;
    try {
      return await _channel.invokeMethod<bool>('openUrl', value) ?? false;
    } on MissingPluginException {
      return false;
    }
  }
}
