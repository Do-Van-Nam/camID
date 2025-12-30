import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle headerBlack = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_1618,
    fontSize: 16
  );

  static TextStyle headerWhite = AppTextFonts.poppinsSemiBold.copyWith(
      color: AppColors.color_FFFF,
      fontSize: 16
  );

  static TextStyle title = AppTextFonts.poppinsSemiBold.copyWith(
      color: AppColors.color_1618,
      fontSize: 18
  );

  static TextStyle content = AppTextFonts.poppinsRegular.copyWith(
      color: AppColors.color_464B,
      fontSize: 14
  );

  static TextStyle textButtonLight = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_FFFF,
    fontSize: 16
  );

  static TextStyle textButtonBlack = AppTextFonts.poppinsSemiBold.copyWith(
      color: AppColors.color_1618,
      fontSize: 16
  );
}