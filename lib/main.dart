import 'dart:ui';

import 'package:cam_id/app.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:cam_id/main/utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirstOpenApp =
      await SharePreferenceUtil.getBool(ShareKey.KEY_FIRST_OPEN_APP) ?? false;
  AppConfig.instance.isFirstOpenApp = isFirstOpenApp;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsBinding.instance.addObserver(AppLifecycleHandler());
  final user = await SharePreferenceUtil.getUser();
  AppLogger().logInfo("Main user: ${UserInfoModel.instance.username}");
  final languageCode = await SharePreferenceUtil.getLanguageCode();
  await SharePreferenceUtil.saveLanguage(languageCode);

  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  runApp(const App());
}

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
    }
  }
}