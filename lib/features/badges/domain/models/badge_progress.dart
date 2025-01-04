import 'package:freezed_annotation/freezed_annotation.dart';
import 'badge_level.dart';

part 'badge_progress.freezed.dart';
part 'badge_progress.g.dart';

@freezed
class BadgeProgress with _$BadgeProgress {
  const factory BadgeProgress({
    required BadgeLevel currentLevel,
    required int booksRead,
    required int favoriteBooks,
    required int readingStreak,
    required DateTime lastUpdated,
  }) = _BadgeProgress;

  factory BadgeProgress.initial() => BadgeProgress(
        currentLevel: BadgeLevel.beginner,
        booksRead: 0,
        favoriteBooks: 0,
        readingStreak: 0,
        lastUpdated: DateTime.now(),
      );

  factory BadgeProgress.fromJson(Map<String, dynamic> json) =>
      _$BadgeProgressFromJson(json);
}
