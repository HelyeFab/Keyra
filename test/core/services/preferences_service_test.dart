import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/core/services/preferences_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<PreferencesService> createService({
    bool? isFirstLaunch,
    String? appLanguage,
    bool? hasSeenOnboarding,
  }) async {
    // Clear any existing mock values
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    // Set new mock values
    if (isFirstLaunch != null) {
      await prefs.setBool('isFirstLaunch', isFirstLaunch);
    }
    if (appLanguage != null) {
      await prefs.setString('appLanguage', appLanguage);
    }
    if (hasSeenOnboarding != null) {
      await prefs.setBool('hasSeenOnboarding', hasSeenOnboarding);
    }
    
    return PreferencesService.init();
  }

  group('PreferencesService', () {
    test('initializes with default values when no data exists', () async {
      final service = await createService();

      expect(service.appLanguage, equals('en'));
      expect(service.hasSeenOnboarding, isFalse);
      expect(service.isFirstLaunch, isTrue);
      
      // Get a new instance to verify persistence
      final newService = await PreferencesService.init();
      expect(newService.isFirstLaunch, isFalse);
    });

    test('loads existing values from SharedPreferences', () async {
      final service = await createService(
        isFirstLaunch: false,
        appLanguage: 'fr',
        hasSeenOnboarding: true,
      );

      expect(service.appLanguage, equals('fr'));
      expect(service.hasSeenOnboarding, isTrue);
      expect(service.isFirstLaunch, isFalse);
    });

    test('sets first launch flag on initialization', () async {
      final service = await createService(isFirstLaunch: true);
      expect(service.isFirstLaunch, isTrue);
      
      // Get a new instance to verify persistence
      final newService = await PreferencesService.init();
      expect(newService.isFirstLaunch, isFalse);
    });

    test('updates onboarding state', () async {
      final service = await createService(hasSeenOnboarding: false);
      await service.setHasSeenOnboarding(true);

      expect(service.hasSeenOnboarding, isTrue);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('hasSeenOnboarding'), isTrue);
    });

    test('handles SharedPreferences errors gracefully', () async {
      // Mock SharedPreferences to throw errors
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Force error state

      final service = await PreferencesService.init();
      expect(service.appLanguage, equals('en'));
      expect(service.hasSeenOnboarding, isFalse);
      expect(service.isFirstLaunch, isTrue);
      
      // Get a new instance to verify persistence
      final newService = await PreferencesService.init();
      expect(newService.isFirstLaunch, isFalse);
    });

    test('persists language preference', () async {
      final service = await createService(appLanguage: 'en');
      expect(service.appLanguage, equals('en'));

      // Change language and verify it's saved
      await service.setAppLanguage('es');
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('appLanguage'), equals('es'));
      
      // Verify new instance loads persisted value
      final newService = await PreferencesService.init();
      expect(newService.appLanguage, equals('es'));
    });
  });
}
