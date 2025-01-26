part of 'dashboard_bloc.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.error(String message) = _Error;
  const factory DashboardState.loaded({
    required int booksRead,
    required int favoriteBooks,
    required int readingStreak,
    required int savedWords,
    required bool isPremium,
    required int? bookLimit,
  }) = _Loaded;
}
