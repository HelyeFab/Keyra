import '../models/saved_word.dart';

class SpacedRepetitionService {
  // Constants for the SuperMemo-2 algorithm
  static const double _minEaseFactor = 1.3;
  static const int _maxInterval = 365; // Maximum interval of 1 year

  /// Calculate the next review schedule based on the response quality
  /// quality: 0 = Hard, 1 = Good, 2 = Easy
  SavedWord calculateNextReview(SavedWord word, int quality) {
    // Convert our 0-2 quality scale to SuperMemo's 0-5 scale
    final smQuality = quality * 2 + 1; // 0->1, 1->3, 2->5

    // Calculate new ease factor
    final newEaseFactor = word.easeFactor +
        (0.1 - (5 - smQuality) * (0.08 + (5 - smQuality) * 0.02));
    
    // Ensure ease factor doesn't go below minimum
    final adjustedEaseFactor = newEaseFactor.clamp(_minEaseFactor, double.infinity);

    // Calculate new interval based on SuperMemo-2 algorithm
    int newInterval;
    if (word.repetitions == 0) {
      newInterval = 1; // First review: 1 day
    } else if (word.repetitions == 1) {
      newInterval = quality == 0 ? 1 : 6; // Second review: 1 day if hard, 6 days otherwise
    } else {
      // For subsequent reviews, multiply the previous interval by ease factor
      newInterval = (word.interval * adjustedEaseFactor).round();
      
      // Adjust interval based on quality
      if (quality == 0) { // Hard
        newInterval = (newInterval * 0.5).round(); // Reduce interval by half
        newInterval = newInterval.clamp(1, word.interval); // Don't increase interval on hard
      } else if (quality == 2) { // Easy
        newInterval = (newInterval * 1.3).round(); // Increase interval by 30%
      }
    }

    // Cap the interval at maximum value
    newInterval = newInterval.clamp(1, _maxInterval);

    // Calculate new progress
    int newProgress;
    if (quality == 0) { // Hard
      newProgress = word.progress > 0 ? word.progress - 1 : 0;
    } else if (quality == 1) { // Good
      newProgress = word.progress < 2 ? word.progress + 1 : 2;
    } else { // Easy
      newProgress = 2;
    }

    // Update the word with new spaced repetition values
    return word.copyWith(
      progress: newProgress,
      difficulty: quality,
      lastReviewed: DateTime.now(),
      repetitions: word.repetitions + 1,
      easeFactor: adjustedEaseFactor,
      interval: newInterval,
    );
  }

  /// Check if a word is due for review
  bool isDueForReview(SavedWord word) {
    if (word.lastReviewed == null) {
      return true; // New word, never reviewed
    }

    final now = DateTime.now();
    final dueDate = word.lastReviewed!.add(Duration(days: word.interval));
    return now.isAfter(dueDate);
  }

  /// Get the next review date for a word
  DateTime getNextReviewDate(SavedWord word) {
    if (word.lastReviewed == null) {
      return DateTime.now(); // New word, review immediately
    }
    return word.lastReviewed!.add(Duration(days: word.interval));
  }

  /// Get all words that are due for review
  List<SavedWord> getDueWords(List<SavedWord> words) {
    return words.where(isDueForReview).toList();
  }
}
