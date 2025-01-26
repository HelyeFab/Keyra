import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockSharedPreferences mockPrefs;
  late ThemeBloc themeBloc;

  setUp(() {
    // Set up platform brightness for testing
    final platformBrightness = TestWidgetsFlutterBinding.instance.platformDispatcher;
    platformBrightness.platformBrightnessTestValue = Brightness.dark;
    
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    themeBloc = ThemeBloc(mockPrefs);
  });

  tearDown(() {
    themeBloc.close();
  });

  group('ThemeBloc', () {
    test('initial state is dark theme', () {
      expect(themeBloc.state.themeMode, equals(ThemeMode.dark));
    });

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeMode.system] when toggle is called from dark mode',
      build: () => themeBloc,
      act: (bloc) => bloc.add(const ThemeEvent.toggleTheme()),
      expect: () => [const ThemeState(themeMode: ThemeMode.system)],
      verify: (_) {
        verify(() => mockPrefs.setString('theme_mode', 'system')).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits correct states when toggling through all modes',
      build: () {
        // Reset mock to ensure clean verification
        reset(mockPrefs);
        when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
        return themeBloc;
      },
      act: (bloc) => bloc
        ..add(const ThemeEvent.toggleTheme())  // dark -> system
        ..add(const ThemeEvent.toggleTheme())  // system -> light
        ..add(const ThemeEvent.toggleTheme()), // light -> dark
      expect: () => [
        const ThemeState(themeMode: ThemeMode.system),
        const ThemeState(themeMode: ThemeMode.light),
        const ThemeState(themeMode: ThemeMode.dark),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeMode.light] when setTheme is called with light mode',
      build: () => themeBloc,
      act: (bloc) => bloc.add(const ThemeEvent.setTheme(ThemeMode.light)),
      expect: () => [const ThemeState(themeMode: ThemeMode.light)],
      verify: (_) {
        verify(() => mockPrefs.setString('theme_mode', 'light')).called(1);
      },
    );

    test('loads saved theme from SharedPreferences', () async {
      // Reset mock to ensure clean verification
      reset(mockPrefs);
      when(() => mockPrefs.getString('theme_mode')).thenReturn('light');
      
      themeBloc = ThemeBloc(mockPrefs);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      expect(themeBloc.state.themeMode, equals(ThemeMode.light));
      verify(() => mockPrefs.getString('theme_mode')).called(1);
    });

    test('handles invalid saved theme value gracefully', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('invalid_value');
      themeBloc = ThemeBloc(mockPrefs);
      
      expect(themeBloc.state.themeMode, equals(ThemeMode.dark));
    });

    test('handles SharedPreferences error gracefully', () {
      when(() => mockPrefs.getString('theme_mode')).thenThrow(Exception('Storage error'));
      themeBloc = ThemeBloc(mockPrefs);
      
      expect(themeBloc.state.themeMode, equals(ThemeMode.dark));
    });

    test('handles save error gracefully', () {
      when(() => mockPrefs.setString(any(), any())).thenThrow(Exception('Storage error'));
      
      // Should not throw error when saving fails
      expect(
        () => themeBloc.add(const ThemeEvent.setTheme(ThemeMode.light)),
        returnsNormally,
      );
    });

    blocTest<ThemeBloc, ThemeState>(
      'handles system theme integration correctly',
      build: () => themeBloc,
      act: (bloc) => bloc.add(const ThemeEvent.setTheme(ThemeMode.system)),
      expect: () => [const ThemeState(themeMode: ThemeMode.system)],
      verify: (_) {
        verify(() => mockPrefs.setString('theme_mode', 'system')).called(1);
      },
    );

    test('create factory method initializes with SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final bloc = await ThemeBloc.create();
      // Wait for the initial theme to be loaded
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(bloc.state.themeMode, equals(ThemeMode.light));
      await bloc.close();
    });
  });
}
