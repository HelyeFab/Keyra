import 'dart:async';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/core/ui_language/bloc/ui_language_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockPlatformDispatcher extends Mock implements PlatformDispatcher {
  @override
  List<Locale> get locales => _locales;
  List<Locale> _locales = [const Locale('en')];
  
  void updateLocales(List<Locale> newLocales) {
    _locales = newLocales;
  }
}

void main() {
  late MockSharedPreferences mockPrefs;
  late UiLanguageBloc uiLanguageBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockPrefs = MockSharedPreferences();
    uiLanguageBloc = UiLanguageBloc(mockPrefs);
  });

  tearDown(() {
    uiLanguageBloc.close();
  });

  group('UiLanguageBloc Tests', () {
    test('Initial state is English', () {
      expect(uiLanguageBloc.state.languageCode, equals('en'));
    });

    test('Changes language when ChangeUiLanguageEvent is added', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      final expectedState = uiLanguageBloc.stream.firstWhere(
        (state) => state.languageCode == 'fr'
      );

      uiLanguageBloc.add(ChangeUiLanguageEvent('fr'));
      
      final actualState = await expectedState;
      expect(actualState.languageCode, equals('fr'));
    });

    test('Loads saved language on LoadSavedUiLanguageEvent', () async {
      when(() => mockPrefs.getString(any())).thenReturn('it');

      final expectedState = uiLanguageBloc.stream.firstWhere(
        (state) => state.languageCode == 'it'
      );

      uiLanguageBloc.add(LoadSavedUiLanguageEvent());
      
      final actualState = await expectedState;
      expect(actualState.languageCode, equals('it'));
    });

    test('Uses device language if no saved preference and device language is supported', () async {
      // Set up mock platform dispatcher with Italian locale
      final mockPlatformDispatcher = MockPlatformDispatcher();
      mockPlatformDispatcher.updateLocales([const Locale('it')]);

      // Mock no saved preference
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Create a new bloc instance with mock platform dispatcher
      final testBloc = UiLanguageBloc(mockPrefs, platformDispatcher: mockPlatformDispatcher);

      try {
        // Add event and wait for state change
        testBloc.add(LoadSavedUiLanguageEvent());
        
        // Wait for the state to change with timeout
        final state = await testBloc.stream.first.timeout(
          const Duration(seconds: 2),
          onTimeout: () => throw TimeoutException('Bloc did not emit new state'),
        );
        expect(state.languageCode, equals('it'));
      } finally {
        await testBloc.close();
      }
    });

    test('Defaults to English if device language is not supported', () async {
      // Set up mock platform dispatcher with Chinese locale
      final mockPlatformDispatcher = MockPlatformDispatcher();
      mockPlatformDispatcher.updateLocales([const Locale('zh')]);

      // Mock no saved preference
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Create a new bloc instance with mock platform dispatcher
      final testBloc = UiLanguageBloc(mockPrefs, platformDispatcher: mockPlatformDispatcher);

      try {
        // Add event and wait for state change
        testBloc.add(LoadSavedUiLanguageEvent());
        
        // Wait for the state to change with timeout
        final state = await testBloc.stream.first.timeout(
          const Duration(seconds: 2),
          onTimeout: () => throw TimeoutException('Bloc did not emit new state'),
        );
        expect(state.languageCode, equals('en'));
      } finally {
        await testBloc.close();
      }
    });

    test('Saves language preference when changed', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      await Future(() {
        uiLanguageBloc.add(ChangeUiLanguageEvent('de'));
      });

      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => mockPrefs.setString(any(), 'de')).called(1);
    });
  });
}
