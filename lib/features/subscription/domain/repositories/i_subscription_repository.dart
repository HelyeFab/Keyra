import '../entities/subscription.dart';

abstract class ISubscriptionRepository {
  Future<Subscription?> getCurrentSubscription();
  Future<List<Subscription>> getSubscriptionHistory();
  Future<void> updateSubscription(Subscription subscription);
  Future<void> cancelSubscription();
  Future<bool> checkSubscriptionAccess(String feature);
  Future<void> createSubscriptionForUser(String userId);
}
