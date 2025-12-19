import 'package:cam_id/app.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cam_id/main/utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirstOpenApp = await SharePreferenceUtil.getBool(ShareKey.KEY_FIRST_OPEN_APP) ?? false;
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

  runApp(App());

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
