import 'package:flutter_bloc/flutter_bloc.dart';
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

  UiLanguageBloc(this._prefs) : super(const UiLanguageState('en')) {
    on<ChangeUiLanguageEvent>((event, emit) async {
      await _prefs.setString(_languageKey, event.languageCode);
      emit(UiLanguageState(event.languageCode));
    });

    on<LoadSavedUiLanguageEvent>((event, emit) async {
      final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
      emit(UiLanguageState(savedLanguage));
    });
  }
}
