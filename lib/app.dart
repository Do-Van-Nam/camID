import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/ui/language/languge_state.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/res/app_theme.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'main/ui/splash/splash_bloc.dart';
import 'main/ui/splash/splash_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceUtils.getDeviceInfo();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LanguageBloc()..add(LoadLanguageEvent()),
        ),
        BlocProvider(
          create: (_) => SplashBloc()..add(SplashStarted()),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp.router(
                title: "CamID",
                theme: themeData,
                debugShowCheckedModeBanner: false,
                locale: languageState.locale,
                supportedLocales: const [
                  Locale("en"),
                  Locale("vi"),
                  Locale("km"),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}
