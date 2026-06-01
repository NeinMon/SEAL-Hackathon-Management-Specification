part of '../main.dart';

class AppRoles {
  const AppRoles._();

  static const participant = 'participant';
  static const judge = 'judge';
  static const mentor = 'mentor';
  static const organizer = 'organizer';

  static const participantCreators = {participant, organizer};
  static const scorers = {judge, organizer};
}

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const events = '/events';
  static const teams = '/teams';
  static const submit = '/submit';
  static const judge = '/judge';
  static const notifications = '/notifications';
  static const chat = '/chat';
  static const map = '/map';
  static const profile = '/profile';
  static const organizer = '/organizer';
}

class AppValidators {
  const AppValidators._();

  static bool isValidEmail(String value) {
    final clean = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(clean);
  }

  static bool isValidWebUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.');
  }

  static String? scoreError(double technical, double ui, double innovation) {
    final values = [technical, ui, innovation];
    final inRange = values.every((score) => score >= 0 && score <= 10);
    return inRange ? null : 'Scores must be between 0 and 10.';
  }
}

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

class AppLogger {
  const AppLogger._();

  static void info(String event, [Map<String, Object?>? fields]) {
    debugPrint('[seal][info] $event ${fields ?? const {}}');
  }

  static void error(
    String event,
    Object exception, [
    Map<String, Object?>? fields,
  ]) {
    debugPrint(
      '[seal][error] $event ${fields ?? const {}} message=${FriendlyErrorMapper.message(exception)}',
    );
  }
}

class FriendlyErrorMapper {
  const FriendlyErrorMapper._();

  static String message(Object exception) {
    if (exception is AuthException) return exception.message;
    if (exception is TimeoutException) {
      return 'Connection timed out. Check your network and try again.';
    }
    if (exception is PostgrestException) {
      final text = exception.message.toLowerCase();
      if (exception.code == '42501' || text.contains('row-level security')) {
        return 'Permission denied for this action. Check the logged-in role and make sure the latest RLS migrations are applied.';
      }
      if (exception.code == '23505') {
        return 'This record already exists. Refresh the screen and update the existing item instead.';
      }
      if (exception.code == '23514') {
        return 'The submitted data failed a database rule. Check score ranges, status, and notification type.';
      }
      return exception.message;
    }
    final text = exception.toString();
    if (text.contains('PostgrestException')) {
      return text
          .replaceFirst(RegExp(r'^PostgrestException\(message:\s*'), '')
          .replaceAll(RegExp(r', code:.*$'), '')
          .trim();
    }
    return text.replaceFirst('Exception: ', '').trim();
  }
}

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
