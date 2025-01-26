import '../entities/subscription.dart';
import '../entities/subscription_enums.dart';

extension SubscriptionHelper on Subscription {
  bool get hasAccess => 
    status == SubscriptionStatus.active && endDate.isAfter(DateTime.now());

  bool get hasReachedBookLimit => 
    tier == SubscriptionTier.free && booksRead >= bookLimit;

  bool get canReadBooks {
    if (tier == SubscriptionTier.premium) return true;
    return booksRead < bookLimit;
  }

  bool get canUseStudyFeature => tier == SubscriptionTier.premium;

  bool get shouldIncreaseLimitToday {
    if (tier != SubscriptionTier.free) return false;
    final daysSinceLastIncrease = DateTime.now().difference(lastLimitIncrease).inDays;
    return daysSinceLastIncrease >= 7;
  }

  DateTime get nextLimitIncrease => 
    lastLimitIncrease.add(const Duration(days: 7));

  bool hasReadBook(String bookId) => readBookIds.contains(bookId);

  Subscription incrementBooksRead(String bookId) {
    if (hasReadBook(bookId)) return this;
    return copyWith(
      booksRead: booksRead + 1,
      readBookIds: [...readBookIds, bookId],
    );
  }

  Subscription incrementBookLimit() {
    if (!shouldIncreaseLimitToday) return this;
    return copyWith(
      bookLimit: bookLimit + 1,
      lastLimitIncrease: DateTime.now(),
    );
  }
}
