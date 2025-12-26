import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorMain),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.color_F6F6,

  // appBarTheme: AppBarTheme(
  //   backgroundColor: AppColors.colorMain,
  //   foregroundColor: Colors.white,
  //   elevation: 0,
  //   systemOverlayStyle: SystemUiOverlayStyle(
  //     statusBarColor: AppColors.colorMain,
  //     statusBarIconBrightness: Brightness.light, // icon trắng
  //     statusBarBrightness: Brightness.dark, // iOS
  //   ),
  // ),
);
