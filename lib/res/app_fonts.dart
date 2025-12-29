import 'package:flutter/material.dart';

class AppTextFonts {
  static const TextStyle poppinsThin = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w100,
  );

  static const TextStyle poppinsExtraLight = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w200,
  );

  static const TextStyle poppinsLight = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );

  static const TextStyle poppinsRegular = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle poppinsMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle poppinsSemiBold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsBold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle poppinsExtraBold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w800,
  );

  static const TextStyle poppinsBlack = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  // ------------------------------------------- N ---------------------------------
  /// TextStyle: Poppins, weight 400, regular, 12px font, 16px line-height, 0 letter-spacing
  static const TextStyle poppins12Regular = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
    height: 16.0 / 12.0,
    letterSpacing: 0.0,
    // Note: Flutter does not have a direct "leading-trim" property; default behavior is used.
  );

  /// TextStyle: Poppins, weight 600, semiBold, 16px font, 24px line-height, 0 letter-spacing
  static const TextStyle poppins16SemiBold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 20.0,
    height: 24.0 / 20.0,
    letterSpacing: 0.0,
    // Note: Flutter does not support "leading-trim" directly; default behavior is used.
  );
  static const TextStyle poppins12RegularCentered = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
    height: 16.0 / 12.0,
    letterSpacing: 0.0,
  );

  static const TextAlign poppins12RegularTextAlign = TextAlign.center;
}
