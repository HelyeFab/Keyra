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
    Color(0xFFE2ED69), // Lightest
    Color(0xFF7FDC85),
    Color(0xFF00C2A5),
    Color(0xFF00A2B4),
    Color(0xFF007FA8),
    Color(0xFF066D9C),
    Color(0xFF155C8E),
    Color(0xFF204A7E),
    Color(0xFF25467A),
    Color(0xFF294175),
    Color(0xFF2D3D71),
    Color(0xFF30396C), // Darkest
  ];
  static const splashBubbleColor = Color(0xFF00C2A5);
  static const splashKeyraText = Colors.orange;
  static const splashKeyraBorder = Color(0xFF666666); // Medium grey for Keyra text border
  static const splashText = Color(0xFFED7769); // Coral/salmon text for splash screen
  static const splashWelcomeText = Color(0xFFFFFFFF); // White text for "Welcome to"
  static const splashKeyraTextShadow = Color(0xFFFAF8F8); // White shadow for Keyra text
  static const splashBoxShadow = Color(0x1A000000); // 10% black for box shadow
  static const splashBubbleShadow = Color(0x14000000); // 8% black for bubble shadow

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

  // Subscription colors
  static const Color subscriptionCardLight = Color(0xFF1E2A38); // Dark blue
  static const Color subscriptionCardDark = Color(0xFF1E2A38); // Same dark blue
  static const Color subscriptionHighlight = Color(0xFF00E5C3); // Bright aqua
  static const Color subscriptionStar = Color(0xFFFFD700); // Gold for star icon
  static const Color subscriptionBorder = Color(0xFF00E5C3); // Aqua for border
  static const Color subscriptionText = Color(0xFFFFFFFF); // White text
  static const Color subscriptionSubtext = Color(0xFF8E9BAE); // Muted text

  // Dictionary colors
  static const Color kanjiSectionLight = Color.fromARGB(255, 255, 252, 222); // Light yellow for kanji section
  static const Color kanjiSectionDark = Color(0xFF3D3A1F); // Dark yellow-tinted for dark mode
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
