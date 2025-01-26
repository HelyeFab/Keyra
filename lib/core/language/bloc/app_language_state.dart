part of 'app_language_bloc.dart';

@freezed
class AppLanguageState with _$AppLanguageState {
  const factory AppLanguageState.initial(String languageCode) = _Initial;
  const factory AppLanguageState.changed(String languageCode) = _Changed;
}
