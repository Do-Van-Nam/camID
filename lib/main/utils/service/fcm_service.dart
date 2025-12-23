import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _requestPermission();
    await _getToken();
    _listenForeground();
    _listenOpenApp();
  }

  /// Xin quyền notification
  Future<void> _requestPermission() async {
    NotificationSettings settings =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔐 Permission: ${settings.authorizationStatus}');
  }

  /// Lấy FCM token
  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    print('📱 FCM Token: $token');

    // TODO: gửi token về backend
  }

  /// App đang mở
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
      LocalNotificationService.instance.showFromFCM(message);
    });
  }

  /// Click notification mở app
  void _listenOpenApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 Opened from notification');
      print('Data: ${message.data}');
    });
  }
}
