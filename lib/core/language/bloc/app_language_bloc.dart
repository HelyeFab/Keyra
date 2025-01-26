import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_language_event.dart';
part 'app_language_state.dart';
part 'app_language_bloc.freezed.dart';

class AppLanguageBloc extends Bloc<AppLanguageEvent, AppLanguageState> {
  final SharedPreferences _prefs;
  static const String _languageKey = 'app_ui_language';

  AppLanguageBloc(this._prefs) : super(const AppLanguageState.initial('en')) {
    on<AppLanguageEvent>((event, emit) async {
      await event.when(
        changeLanguage: (String languageCode) async {
          await _prefs.setString(_languageKey, languageCode);
          emit(AppLanguageState.changed(languageCode));
        },
        loadSavedLanguage: () async {
          final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
          emit(AppLanguageState.changed(savedLanguage));
        },
      );
    });
  }
}
