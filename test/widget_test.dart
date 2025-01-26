import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/splash_screen.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:mockito/mockito.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/core/theme/text_themes.dart';

class MockPreferencesService extends Mock implements PreferencesService {
  @override
  bool hasSeenOnboarding = false;
}

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    final mockPreferencesService = MockPreferencesService();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.darkSurface,
            brightness: Brightness.dark,
          ),
          textTheme: AppTextTheme.textTheme,
        ),
        home: SplashScreen(
          isInitialized: true,
          isFirstLaunch: true,
          preferencesService: mockPreferencesService,
        ),
      ),
    );

    // Wait for animations to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify welcome text
    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('KEYRA'), findsOneWidget);
    expect(
      find.text('Your journey to mastering languages starts here'),
      findsOneWidget,
    );

    // Verify some language bubbles
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Bonjour'), findsOneWidget);
  });
}
