import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_bloc.freezed.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';
  static const String _gradientThemePreferenceKey = 'use_gradient_theme';
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs) : super(const ThemeState(themeMode: ThemeMode.system, useGradientTheme: false)) {
    on<ThemeEvent>((event, emit) {
      event.when(
        toggleTheme: () {
          if (!state.useGradientTheme) {
            final newMode = state.themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
            _saveThemeMode(newMode);
            emit(state.copyWith(themeMode: newMode));
          }
        },
        setTheme: (ThemeMode mode) {
          if (!state.useGradientTheme) {
            _saveThemeMode(mode);
            emit(state.copyWith(themeMode: mode));
          }
        },
        toggleGradientTheme: () {
          final newGradientState = !state.useGradientTheme;
          _saveGradientTheme(newGradientState);
          emit(state.copyWith(useGradientTheme: newGradientState));
        },
        setGradientTheme: (bool useGradient) {
          _saveGradientTheme(useGradient);
          emit(state.copyWith(useGradientTheme: useGradient));
        },
      );
    });
    
    // Load saved theme immediately
    _loadSavedTheme();
    _loadSavedGradientTheme();
  }

  static Future<ThemeBloc> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeBloc(prefs);
  }

  void _loadSavedTheme() {
    try {
      final savedMode = _prefs.getString(_themePreferenceKey);
      if (savedMode != null) {
        final themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
        add(ThemeEvent.setTheme(themeMode));
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  void _loadSavedGradientTheme() {
    try {
      final useGradient = _prefs.getBool(_gradientThemePreferenceKey) ?? false;
      add(ThemeEvent.setGradientTheme(useGradient));
    } catch (e) {
      debugPrint('Error loading gradient theme: $e');
    }
  }

  void _saveThemeMode(ThemeMode mode) {
    try {
      _prefs.setString(_themePreferenceKey, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  void _saveGradientTheme(bool useGradient) {
    try {
      _prefs.setBool(_gradientThemePreferenceKey, useGradient);
    } catch (e) {
      debugPrint('Error saving gradient theme: $e');
    }
  }
}
