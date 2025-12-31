import 'dart:async';
import 'dart:ui';

import 'package:cam_id/app.dart';
import 'package:cam_id/appInitializer.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:ipcc_plugin/ipcc_plugin.dart';

import 'firebase_options.dart';
import 'main/utils/service/fcm_service.dart';
import 'main/utils/service/local_notification_service.dart';
import 'main/utils/service/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (await SharePreferenceUtil.getBool(ShareKey.KEY_CHANGE_OPEN_APP) == true) {
    await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
  }
  bool isFirstOpenApp = await SharePreferenceUtil.getBool(
    ShareKey.KEY_FIRST_OPEN_APP,
  );
  AppConfig.instance.isFirstOpenApp = isFirstOpenApp;

  WidgetsBinding.instance.addObserver(AppLifecycleHandler());
  final user = await SharePreferenceUtil.getUser();
  AppLogger().logInfo("Main user: ${UserInfoModel.instance.username}");
  final languageCode = await SharePreferenceUtil.getLanguageCode();
  await SharePreferenceUtil.saveLanguage(languageCode);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await LocalNotificationService.instance.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await RemoteConfigService().init();

  unawaited(FcmService().init());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // hoặc màu tối
      statusBarIconBrightness: Brightness.light, // Android: icon trắng
      statusBarBrightness: Brightness.dark, // iOS: icon trắng
    ),
  );
  runApp(const AppInitializer());
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
