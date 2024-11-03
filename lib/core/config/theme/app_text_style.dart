import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String _FONT_FAMILY = 'Montserrat';
  static double baseFontSize = 1.0; // Untuk ukuran dasar

  static void setBaseFontSize(BuildContext context) {
    // Mengatur ukuran dasar berdasarkan lebar layar
    double screenWidth = MediaQuery.of(context).size.width;
    baseFontSize = screenWidth / 375; // 375 adalah ukuran referensi
  }

  static TextStyle title1 = TextStyle(
    fontSize: 24 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle title2 = TextStyle(
    fontSize: 20 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle title3 = TextStyle(
    fontSize: 18 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle headline1 = TextStyle(
    fontSize: 16 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle headline2 = TextStyle(
    fontSize: 16 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle bodyTextSemiBold = TextStyle(
    fontSize: 14 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle bodyText = TextStyle(
    fontSize: 14 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle caption1 = TextStyle(
    fontSize: 12 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle caption2 = TextStyle(
    fontSize: 12 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // static TextStyle subtitle = TextStyle(
  //   fontSize: 20 * baseFontSize,
  //   fontFamily: _FONT_FAMILY,
  //   fontWeight: FontWeight.w500,
  //   color: Colors.grey,
  // );

  // static TextStyle smallText = TextStyle(
  //   fontSize: 12 * baseFontSize,
  //   fontFamily: _FONT_FAMILY,
  //   fontWeight: FontWeight.normal,
  //   color: Colors.grey,
  // );

  static TextStyle linkText = TextStyle(
    fontSize: 14 * baseFontSize,
    fontFamily: _FONT_FAMILY,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationThickness: 2,
  );
}
