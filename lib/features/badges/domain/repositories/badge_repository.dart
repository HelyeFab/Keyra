import '../models/badge_progress.dart';

abstract class BadgeRepository {
  /// Get the current badge progress for the user
  Stream<BadgeProgress> getBadgeProgress();

  /// Update the badge progress with new stats
  Future<void> updateBadgeProgress(BadgeProgress progress);

  /// Check if the user has earned a new badge level
  Future<bool> checkForBadgeUpgrade();
}
