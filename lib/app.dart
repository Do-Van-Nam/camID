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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceUtils.getDeviceInfo();
    return BlocProvider(
      create: (_) => LanguageBloc()..add(LoadLanguageEvent()),
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
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: languageState.locale,
                supportedLocales: const [
                  Locale("en"),
                  Locale("vi"),
                ],
                routerConfig: router,
              );
            },
          );
        },
      ),
    );

    // return MultiBlocProvider(
    //   providers: [
    //   //   BlocProvider(
    //   //     create: (context) => LanguageBloc()..add(LoadLanguageEvent()),
    //   //   ),
    //   //   BlocProvider(
    //   //     create: (context) {
    //   //       return NetworkBloc();
    //   //     },
    //   //   ),
    //   //   BlocProvider(create: (context) => VideoBloc()),
    //   //   BlocProvider(create: (context) => DetailVideoBloc()),
    //   ],
    //   child: MultiBlocListener(
    //     listeners: [
    //       // BlocListener<NetworkBloc, NetworkState>(
    //       //   listener: (context, state) {},
    //       // ),
    //     ],
    //     child: BlocBuilder<LanguageBloc, LanguageState>(
    //       builder: (context, languageState) {
    //         return ScreenUtilInit(
    //           designSize: const Size(375, 812),
    //           minTextAdapt: true,
    //           splitScreenMode: true,
    //           builder: (_, child) {
    //             return MaterialApp.router(
    //               title: "CamID",
    //               theme: themeData,
    //               debugShowCheckedModeBanner: false,
    //               localizationsDelegates: [
    //                 // AppLocalizations.delegate,
    //                 GlobalMaterialLocalizations.delegate,
    //                 GlobalWidgetsLocalizations.delegate,
    //                 GlobalCupertinoLocalizations.delegate,
    //               ],
    //               locale: languageState.locale,
    //               supportedLocales: [Locale("en"), Locale("vi")],
    //               routerConfig: router,
    //             );
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
