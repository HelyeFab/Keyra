part of 'theme_bloc.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _ThemeState;
}
