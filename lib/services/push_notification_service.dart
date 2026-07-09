import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/app_helpers.dart';
import '../core/notification_deep_link.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> initialize() async {
    if (_ready || kIsWeb) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        NotificationDeepLink.open(response.payload);
      },
    );
    _ready = true;
  }

  Future<void> showInAppAlert({
    required String title,
    required String body,
    String? payload,
    String? actionLabel,
  }) async {
    if (!_ready) return;
    AppLogger.action('push.local_show', {
      'title': title,
      'payload': payload,
      'action_label': actionLabel,
    });
    final actions = actionLabel != null && actionLabel.trim().isNotEmpty
        ? <AndroidNotificationAction>[
            AndroidNotificationAction(
              'open',
              actionLabel.trim(),
              showsUserInterface: true,
            ),
          ]
        : null;
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'seal_hackathon_alerts',
          'SEAL Hackathon',
          channelDescription: 'Score, team and system alerts',
          importance: Importance.high,
          priority: Priority.high,
          actions: actions,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: actionLabel == null ? null : 'seal_action',
        ),
      ),
      payload: payload,
    );
  }
}
