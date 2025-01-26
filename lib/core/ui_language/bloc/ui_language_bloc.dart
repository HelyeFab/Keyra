import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  UiLanguageBloc(this._prefs) : super(const UiLanguageState('en')) {
    on<ChangeUiLanguageEvent>((event, emit) async {
      await _prefs.setString(_languageKey, event.languageCode);
      emit(UiLanguageState(event.languageCode));
    });

    on<LoadSavedUiLanguageEvent>((event, emit) async {
      try {
        // Try to get saved language preference
        final savedLanguage = _prefs.getString(_languageKey);

        if (savedLanguage != null) {
          emit(UiLanguageState(savedLanguage));
          return;
        }

        // Get device language using Window.locale
        final window = WidgetsBinding.instance.window;
        final deviceLocale = window.locale;
        final deviceLanguage = deviceLocale.languageCode.toLowerCase();
        
        String? matchedLanguage;
        if (supportedLanguages.containsKey(deviceLanguage)) {
          matchedLanguage = deviceLanguage;
        }

        if (matchedLanguage != null) {
          // Save and use matched device language
          await _prefs.setString(_languageKey, matchedLanguage);
          emit(UiLanguageState(matchedLanguage));
        } else {
          // Default to English if no supported language found
          await _prefs.setString(_languageKey, 'en');
          emit(const UiLanguageState('en'));
        }
      } catch (e) {
        // Default to English on error
        await _prefs.setString(_languageKey, 'en');
        emit(const UiLanguageState('en'));
      }
    });
  }
}
