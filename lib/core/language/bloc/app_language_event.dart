part of 'app_language_bloc.dart';

@freezed
class AppLanguageEvent with _$AppLanguageEvent {
  const factory AppLanguageEvent.changeLanguage(String languageCode) = _ChangeLanguage;
  const factory AppLanguageEvent.loadSavedLanguage() = _LoadSavedLanguage;
}
