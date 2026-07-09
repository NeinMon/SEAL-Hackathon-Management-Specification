import 'package:flutter/foundation.dart';

import 'friendly_error_mapper.dart';

class AppLogger {
  const AppLogger._();

  static void info(String event, [Map<String, Object?>? fields]) {
    debugPrint('[seal][info] $event ${_safeFields(fields)}');
  }

  static void action(String event, [Map<String, Object?>? fields]) {
    debugPrint('[seal][action] $event ${_safeFields(fields)}');
  }

  static void error(
    String event,
    Object exception, [
    Map<String, Object?>? fields,
  ]) {
    debugPrint(
      '[seal][error] $event ${_safeFields(fields)} message=${FriendlyErrorMapper.message(exception)}',
    );
  }

  static Map<String, Object?> _safeFields(Map<String, Object?>? fields) {
    if (fields == null) return const {};
    return {
      for (final entry in fields.entries)
        if (!_sensitiveKeys.contains(entry.key.toLowerCase()))
          entry.key: entry.value,
    };
  }

  static const _sensitiveKeys = {
    'password',
    'token',
    'apikey',
    'api_key',
    'anonkey',
    'anon_key',
    'servicerolekey',
    'service_role_key',
  };
}
