import 'package:flutter/material.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_bloc.freezed.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs)
      : super(const ThemeState(themeMode: ThemeMode.dark)) {
    on<ThemeEvent>((event, emit) {
      event.when(
        toggleTheme: () {
          final ThemeMode newMode;
          switch (state.themeMode) {
            case ThemeMode.system:
              // When in system mode, switch to explicit light/dark based on current system preference
              final brightness = WidgetsBinding.instance.window.platformBrightness;
              newMode = brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
              break;
            case ThemeMode.light:
              newMode = ThemeMode.dark;
              break;
            case ThemeMode.dark:
              newMode = ThemeMode.system;
              break;
          }
          _saveThemeMode(newMode);
          emit(state.copyWith(themeMode: newMode));
        },
        setTheme: (ThemeMode mode) {
          _saveThemeMode(mode);
          emit(state.copyWith(themeMode: mode));
        },
      );
    });

    // Load saved theme immediately
    _loadSavedTheme();
  }

  static Future<ThemeBloc> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeBloc(prefs);
  }

  void _loadSavedTheme() {
    try {
      final savedMode = _prefs.getString(_themePreferenceKey);
      if (savedMode != null) {
        ThemeMode themeMode;
        switch (savedMode) {
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'system':
            themeMode = ThemeMode.system;
            break;
          default:
            themeMode = ThemeMode.dark;
        }
        add(ThemeEvent.setTheme(themeMode));
      } else {
        // If no saved preference, default to dark theme
        add(const ThemeEvent.setTheme(ThemeMode.dark));
      }
    } catch (e) {
      Logger.error('Failed to load theme', error: e);
    }
  }

  void _saveThemeMode(ThemeMode mode) {
    try {
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      _prefs.setString(_themePreferenceKey, themeString);
    } catch (e) {
      Logger.error('Failed to save theme', error: e);
    }
  }
}
