import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/splash_screen.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:mockito/mockito.dart';

class MockPreferencesService extends Mock implements PreferencesService {
  @override
  bool hasSeenOnboarding = false;
}

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    final mockPreferencesService = MockPreferencesService();

    await tester.pumpWidget(
      SplashScreen(
        isInitialized: true,
        isFirstLaunch: true,
        preferencesService: mockPreferencesService,
      ),
    );
    expect(find.text('A fun way to'), findsOneWidget);
    expect(find.text('Learn a new language'), findsOneWidget);
  });
}
