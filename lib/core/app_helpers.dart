import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';

class AppRoles {
  const AppRoles._();

  static const participant = 'participant';
  static const judge = 'judge';
  static const mentor = 'mentor';
  static const organizer = 'organizer';

  static const participantCreators = {participant, organizer};
  static const scorers = {judge, organizer};

  static String label(String role) {
    return switch (role) {
      participant => 'Thí sinh',
      judge => 'Giám khảo',
      mentor => 'Mentor',
      organizer => 'Ban tổ chức',
      _ => role,
    };
  }
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
    return inRange ? null : 'Điểm phải nằm trong khoảng 0 đến 10.';
  }
}

class AppLabels {
  const AppLabels._();

  static String submissionStatus(String status) {
    return switch (status) {
      'reviewed' => 'Đã chấm',
      'submitted' => 'Đã nộp',
      'draft' => 'Bản nháp',
      _ => status,
    };
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

class FriendlyErrorMapper {
  const FriendlyErrorMapper._();

  static bool looksLikeNetworkError(Object exception) {
    final text = exception.toString().toLowerCase();
    return exception is TimeoutException ||
        text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection') ||
        text.contains('timed out') ||
        text.contains('failed host lookup');
  }

  static String message(Object exception) {
    if (exception is AuthException) return exception.message;
    if (exception is TimeoutException) {
      return 'Kết nối quá lâu. Kiểm tra mạng rồi thử lại.';
    }
    if (exception is PostgrestException) {
      final text = exception.message.toLowerCase();
      if (exception.code == '42501' || text.contains('row-level security')) {
        return 'Tài khoản hiện tại không có quyền thực hiện thao tác này. Kiểm tra role đăng nhập và migrations RLS.';
      }
      if (exception.code == '23505') {
        return 'Dữ liệu này đã tồn tại. Tải lại màn hình rồi cập nhật bản ghi hiện có.';
      }
      if (exception.code == '23514') {
        return 'Dữ liệu chưa đạt quy tắc của database. Kiểm tra điểm, trạng thái và loại thông báo.';
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
