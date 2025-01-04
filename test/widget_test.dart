import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/main.dart';
import 'package:Keyra/splash_screen.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Hive.initFlutter();
    await dotenv.load(fileName: '.env');
  });

  tearDown(() async {
    await Hive.close();
  });

  testWidgets('App initializes with splash screen', (WidgetTester tester) async {
    // Initialize required services
    await initServices();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: const [
          // Add mock repositories here as needed for testing
        ],
        child: MaterialApp(
          home: SplashScreen(
            isInitialized: false,
            isFirstLaunch: true,
            preferencesService: await PreferencesService.init(),
          ),
        ),
      ),
    );

    // Verify that splash screen is shown initially
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
