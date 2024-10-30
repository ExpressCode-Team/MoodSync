import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String _FONT_FAMILY = 'Montserrat';

  static const TextStyle title1 = TextStyle(
    fontSize: 24,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 20,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 18,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 16,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 16,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const TextStyle bodyTextSemiBold = TextStyle(
    fontSize: 14,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 12,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // static const TextStyle subtitle = TextStyle(
  //   fontSize: 20,
  //   fontFamily: _FONT_FAMILY,
  //   fontWeight: FontWeight.w500,
  //   color: Colors.grey,
  // );

  // static const TextStyle smallText = TextStyle(
  //   fontSize: 12,
  //   fontFamily: _FONT_FAMILY,
  //   fontWeight: FontWeight.normal,
  //   color: Colors.grey,
  // );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationThickness: 2,
  );
}
