import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';
import 'navigation_handler.dart';

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
    _checkInitialMessage();
  }

  /// Xin quyền notification
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
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
      NavigationHandler.instance.handleFcmData(message.data);
    });
  }

  /// App khởi động từ trạng thái kill bằng cách tap notification
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print(
        '🚀 Launched from terminated by notification: ${initialMessage.data}',
      );
      NavigationHandler.instance.handleFcmData(initialMessage.data);
    }
  }
}
