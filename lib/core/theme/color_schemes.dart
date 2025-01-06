import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFF6750A4);
  static const Color lightSecondary = Color(0xFF625B71);
  static const Color lightTertiary = Color(0xFF7D5260);
  static const Color lightBackground = Color(0xFFF6F2FF);
  static const Color lightSurface = Color(0xFFFFFBFE);
  static const Color lightSurfaceVariant = Color(0xFFE7E0EC);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1C1B1F);
  static const Color lightOnSurface = Color(0xFF1C1B1F);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF4B9EFF); // Bright blue
  static const Color darkSecondary = Color(0xFF64B5F6); // Light blue
  static const Color darkTertiary = Color(0xFF90CAF9); // Lighter blue
  static const Color darkBackground = Color(0xFF121B2F); // Deep blue background
  static const Color darkSurface =
      Color(0xFF1A2642); // Slightly lighter deep blue
  static const Color darkSurfaceVariant =
      Color(0xFF243353); // Even lighter deep blue
  static const Color darkSurfaceContainer =
      Color(0xFF1F2B47); // Mid-tone deep blue
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnTertiary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface =
      Color(0xFFE1E3E6); // Lighter gray for better readability

  // Splash screen colors
  static const splashGradient = [
    Color(0xFF041633), // Darker top
    Color(0xFF051834),
    Color(0xFF071A34),
    Color(0xFF0A1C35),
    Color(0xFF0D1E35), // Darker bottom
  ];
  static const splashText =
      Color(0xFFED7769); // Coral/salmon text for splash screen

  // Common colors
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  static const Color playful = Color(0xFFFFAB40);
  static const Color calm = Color(0xFF64DD17);
  static const Color focus = Color(0xFF0091EA);
  static const Color sectionTitle = Color(0xFF2196F3);

  // Control colors for reader
  static const Color readerControl = Color(0xFFF0EBFF);
  static const Color readerControlDark = Color(0xFFD7CFFF);
  static const Color controlPurple = Color(0xFFBB86FC);
  static const Color controlPink = Color(0xFFF48FB1);
  static const Color controlText = Color(0xFF6750A4);
  static const Color controlTextDark = Color(0xFFFFFFFF);

  // Icon colors for navigation
  static const Color icon = Color(0xFF1C1B1F);
  static const Color iconDark = Color(0xFFFFFFFF);

  // Gradient colors for pages
  static const homeGradient = [
    Color(0xFFEB2D7E),
    Color(0xFFEC0593),
    Color(0xFFE600AD),
    Color(0xFFD800CB),
    Color(0xFFBD12EB)
  ];
  static const libraryGradient = [
    Color(0xFFF98D5A),
    Color(0xFFFFB74F),
    Color(0xFFFDCE4E),
    Color(0xFFF5E555)
  ];
  static const studyGradient = [
    Color(0xFF6BD192),
    Color(0xFF5CC07E),
    Color(0xFF4DAE6B),
    Color(0xFF3E9E59),
    Color(0xFF2E8D46),
    Color(0xFF29904E),
    Color(0xFF239455),
    Color(0xFF1B975D),
    Color(0xFF22B081),
    Color(0xFF31C9A6),
    Color(0xFF45E2CC),
    Color(0xFF5FFBF1)
  ];
  static const dashboardGradient = [
    Color(0xFF3D6EDE),
    Color(0xFF0094F5),
    Color(0xFF00B6FD),
    Color(0xFF00D5FA),
    Color(0xFF55F1F5)
  ];
  static const profileGradient = [
    Color(0xFF5ECAA4),
    Color(0xFF63D4B7),
    Color(0xFF6BDDC9),
    Color(0xFF76E7DA),
    Color(0xFF82F0EB)
  ];

  // For backward compatibility
  static const Color primary = lightPrimary;

  // Pastel colors for word cards
  static const Color pastelPink = Color(0xFFFFE5E5);
  static const Color pastelGreen = Color(0xFFE5FFE5);
  static const Color pastelBlue = Color(0xFFE5E5FF);
  static const Color pastelPurple = Color(0xFFFFE5FF);
  static const Color pastelYellow = Color(0xFFFFFFE5);
  static const Color pastelCyan = Color(0xFFE5FFFF);

  static const List<Color> wordCardColors = [
    pastelPink,
    pastelGreen,
    pastelBlue,
    pastelPurple,
    pastelYellow,
    pastelCyan,
  ];

  // Flashcard colors
  static const flashcardHardLight = Color(0xFFCF6679);
  static const flashcardHardDark = Color(0xFF8E0031);
  static const flashcardGoodLight = Color(0xFF81D4FA);
  static const flashcardGoodDark = Color(0xFF0277BD);
  static const flashcardEasyLight = Color(0xFFB9F6CA);
  static const flashcardEasyDark = Color(0xFF1B5E20);
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.lightPrimary,
  onPrimary: AppColors.lightOnPrimary,
  secondary: AppColors.lightSecondary,
  onSecondary: AppColors.lightOnSecondary,
  tertiary: AppColors.lightTertiary,
  onTertiary: AppColors.lightOnTertiary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.lightSurface,
  onSurface: AppColors.lightOnSurface,
  surfaceContainerHighest: AppColors.lightSurfaceVariant,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.darkPrimary,
  onPrimary: AppColors.darkOnPrimary,
  secondary: AppColors.darkSecondary,
  onSecondary: AppColors.darkOnSecondary,
  tertiary: AppColors.darkTertiary,
  onTertiary: AppColors.darkOnTertiary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  surfaceContainerHighest: AppColors.darkSurfaceVariant,
  surfaceContainerLowest: AppColors.darkSurfaceContainer,
);
