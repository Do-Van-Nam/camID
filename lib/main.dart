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

  // Setup system UI (non-blocking)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase (required before other Firebase services)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup background message handler (non-blocking registration)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Load cached RemoteConfig immediately (fast, no network)
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.loadCachedConfig();

  // Run independent operations in parallel
  final results = await Future.wait([
    // SharePreference reads can run in parallel
    SharePreferenceUtil.getBool(ShareKey.KEY_CHANGE_OPEN_APP).then((
      changeOpen,
    ) async {
      if (changeOpen == true) {
        await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
      }
      return changeOpen;
    }),
    SharePreferenceUtil.getBool(ShareKey.KEY_FIRST_OPEN_APP),
    SharePreferenceUtil.getUser(),
    SharePreferenceUtil.getLanguageCode(),
    LocalNotificationService.instance.init(),
  ]);

  final isFirstOpenApp = results[1] as bool? ?? false;
  AppConfig.instance.isFirstOpenApp = isFirstOpenApp;

  // User is loaded into UserInfoModel.instance by SharePreferenceUtil.getUser()
  AppLogger().logInfo("Main user: ${UserInfoModel.instance.username}");

  final languageCode = results[3] as String?;
  if (languageCode != null) {
    await SharePreferenceUtil.saveLanguage(languageCode);
  }

  WidgetsBinding.instance.addObserver(AppLifecycleHandler());

  // Start app immediately - fetch RemoteConfig in background
  runApp(const App());

  // Fetch fresh RemoteConfig in background (non-blocking)
  unawaited(remoteConfigService.init());

  // Initialize FCM in background (non-blocking)
  unawaited(FcmService().init());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔕 Background message: ${message.toString()}');
  LocalNotificationService.instance.showFromFCM(message);
}

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
    }
  }
}
