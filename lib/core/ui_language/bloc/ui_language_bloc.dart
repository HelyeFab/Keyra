import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

// State
class UiLanguageState {
  final String languageCode;
  const UiLanguageState(this.languageCode);
}

// Events
abstract class UiLanguageEvent {}

class ChangeUiLanguageEvent extends UiLanguageEvent {
  final String languageCode;
  ChangeUiLanguageEvent(this.languageCode);
}

class LoadSavedUiLanguageEvent extends UiLanguageEvent {}

// Bloc
class UiLanguageBloc extends Bloc<UiLanguageEvent, UiLanguageState> {
  final SharedPreferences _prefs;
  static const String _languageKey = 'app_ui_language_preference';

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'fr': 'Français',
    'de': 'Deutsch',
    'es': 'Español',
    'it': 'Italiano',
    'ja': '日本語',
  };

  final PlatformDispatcher platformDispatcher;

  UiLanguageBloc(this._prefs, {PlatformDispatcher? platformDispatcher}) 
      : platformDispatcher = platformDispatcher ?? PlatformDispatcher.instance,
        super(const UiLanguageState('en')) {
    on<ChangeUiLanguageEvent>((event, emit) async {
      await _prefs.setString(_languageKey, event.languageCode);
      emit(UiLanguageState(event.languageCode));
    });

    on<LoadSavedUiLanguageEvent>((event, emit) async {
      // Try to get saved language preference
      final savedLanguage = _prefs.getString(_languageKey);

      if (savedLanguage != null) {
        // Use saved language if it exists
        emit(UiLanguageState(savedLanguage));
      } else {
        // Get device language
        final deviceLocale = platformDispatcher?.locales.firstOrNull ?? const Locale('en');
        final deviceLanguage = deviceLocale.languageCode.toLowerCase();

        // Check if device language is supported
        if (supportedLanguages.containsKey(deviceLanguage)) {
          // Save and use device language
          await _prefs.setString(_languageKey, deviceLanguage);
          emit(UiLanguageState(deviceLanguage));
        } else {
          // Default to English
          await _prefs.setString(_languageKey, 'en');
          emit(const UiLanguageState('en'));
        }
      }
    });
  }
}
