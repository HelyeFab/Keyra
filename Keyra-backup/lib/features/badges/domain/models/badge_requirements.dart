import 'package:freezed_annotation/freezed_annotation.dart';
import 'badge_level.dart';
import 'badge_requirements_config.dart';

part 'badge_requirements.freezed.dart';
part 'badge_requirements.g.dart';

@freezed
class BadgeRequirements with _$BadgeRequirements {
  const factory BadgeRequirements({
    required BadgeLevel level,
    required String displayName,
    required String assetPath,
    required int requiredBooksRead,
    required int requiredFavoriteBooks,
    required int requiredReadingStreak,
  }) = _BadgeRequirements;

  factory BadgeRequirements.fromJson(Map<String, dynamic> json) =>
      _$BadgeRequirementsFromJson(json);

  static BadgeRequirements getRequirementsForLevel(BadgeLevel level) {
    return badgeRequirementsConfig[level]!;
  }

  const BadgeRequirements._();

  bool isSatisfiedBy({
    required int booksRead,
    required int favoriteBooks,
    required int readingStreak,
  }) {
    print('[BadgeRequirements] Checking level: $level');
    print('[BadgeRequirements] Books read: $booksRead >= $requiredBooksRead');
    print('[BadgeRequirements] Favorite books: $favoriteBooks >= $requiredFavoriteBooks');
    print('[BadgeRequirements] Reading streak: $readingStreak >= $requiredReadingStreak');
    
    final satisfied = booksRead >= requiredBooksRead &&
        favoriteBooks >= requiredFavoriteBooks &&
        readingStreak >= requiredReadingStreak;
    
    print('[BadgeRequirements] Requirements satisfied: $satisfied');
    return satisfied;
  }

  @override
  String toString() {
    return 'BadgeRequirements(level: $level, required: books=$requiredBooksRead, favorites=$requiredFavoriteBooks, streak=$requiredReadingStreak)';
  }
}