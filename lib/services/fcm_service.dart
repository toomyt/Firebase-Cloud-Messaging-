import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required void Function(RemoteMessage message) onData,
    void Function(String token)? onToken,
  }) async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Permission status: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.messageId}');
      onData(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Opened from background: ${message.messageId}');
      onData(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('Opened from terminated: ${initialMessage.messageId}');
      onData(initialMessage);
    }

    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    if (token != null) {
      onToken?.call(token);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('Token refreshed: $newToken');
      onToken?.call(newToken);
    });
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }
}