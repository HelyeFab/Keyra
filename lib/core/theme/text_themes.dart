import 'package:flutter/material.dart';
import 'font_constants.dart';

class AppTextTheme {
  // This can be changed to test different fonts for the app title
  static const String appTitleFont = AppFonts.paytoneOne;
  static const String bodyFont = AppFonts.roboto;
  static const String headlineFont = AppFonts.poppins;
  
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: appTitleFont,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: appTitleFont,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontFamily: appTitleFont,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontFamily: headlineFont,
        fontSize: 32,
        fontWeight: FontWeight.w700, // Using Bold since we have it
      ),
      headlineMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontFamily: headlineFont,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontFamily: headlineFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );
  }
}
