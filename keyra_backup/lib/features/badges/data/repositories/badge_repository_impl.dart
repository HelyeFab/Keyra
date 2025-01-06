import 'dart:async';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_progress.dart';
import '../../domain/repositories/badge_repository.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  final _progressController = StreamController<BadgeProgress>.broadcast();
  BadgeProgress _currentProgress = BadgeProgress.initial();

  BadgeRepositoryImpl() {
    // Initialize with some mock data
    _currentProgress = BadgeProgress(
      currentLevel: BadgeLevel.beginner,
      booksRead: 3,
      favoriteBooks: 2,
      readingStreak: 1,
      lastUpdated: DateTime.now(),
    );
    _progressController.add(_currentProgress);
  }

  @override
  Stream<BadgeProgress> getBadgeProgress() {
    return _progressController.stream;
  }

  @override
  Future<void> updateBadgeProgress(BadgeProgress progress) async {
    _currentProgress = progress;
    _progressController.add(progress);
  }

  @override
  Future<bool> checkForBadgeUpgrade() async {
    // Mock implementation - always returns false for now
    return false;
  }

  void dispose() {
    _progressController.close();
  }
}
