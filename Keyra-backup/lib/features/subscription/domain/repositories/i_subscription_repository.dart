import 'package:firebase_auth/firebase_auth.dart';
import '../entities/subscription.dart';

abstract class ISubscriptionRepository {
  Future<void> createSubscriptionForUser(User user);
  Future<void> initializeExistingUsersSubscriptions();
  Future<Subscription?> getCurrentSubscription();
  Future<void> updateSubscription(Subscription subscription);
  Future<void> cancelSubscription();
  Future<List<Subscription>> getSubscriptionHistory();
  Future<bool> checkSubscriptionAccess(String feature);
}
