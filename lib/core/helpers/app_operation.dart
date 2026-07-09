import 'dart:async';

import 'app_logger.dart';

class AppOperation {
  const AppOperation._();

  static const timeout = Duration(seconds: 12);

  static Future<T> run<T>(
    String name,
    Future<T> Function() action, {
    int retries = 1,
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        final result = await action().timeout(timeout);
        AppLogger.info(name, {'attempt': attempt, 'status': 'success'});
        return result;
      } catch (exception) {
        AppLogger.error(name, exception, {'attempt': attempt});
        final retryable =
            exception is TimeoutException ||
            exception.toString().toLowerCase().contains('socket') ||
            exception.toString().toLowerCase().contains('connection');
        if (!retryable || attempt > retries) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 350 * attempt));
      }
    }
  }
}
