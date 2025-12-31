import 'dart:async';
import 'dart:ui';

import 'package:cam_id/app.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:cam_id/main/utils/app_config.dart';

import 'firebase_options.dart';
import 'main/utils/service/fcm_service.dart';
import 'main/utils/service/local_notification_service.dart';
import 'main/utils/service/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handlers first (non-blocking)
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Initialize Firebase (required before other Firebase services)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup background message handler (non-blocking registration)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Run independent operations in parallel
  // await LocalNotificationService.instance.init();

  // Start app immediately - fetch RemoteConfig in background
  runApp(const App());

  // Fetch fresh RemoteConfig in background (non-blocking)
  // unawaited(RemoteConfigService().init());

  // Initialize FCM in background (non-blocking)
  // unawaited(FcmService().init());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔕 Background message: ${message.toString()}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalNotificationService.instance.showFromFCM(message);
}
