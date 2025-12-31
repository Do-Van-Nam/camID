import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// System UI Overlay Style cho status bar transparent với icon và text trắng
const SystemUiOverlayStyle appSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // icon trắng
  statusBarBrightness: Brightness.dark, // iOS
);

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorMain),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.color_F6F6,
  appBarTheme: const AppBarTheme(systemOverlayStyle: appSystemUiOverlayStyle),
);
