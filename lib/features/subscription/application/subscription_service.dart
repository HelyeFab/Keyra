import 'package:firebase_auth/firebase_auth.dart';
import '../domain/repositories/i_subscription_repository.dart';
import '../domain/entities/subscription.dart';
import '../domain/entities/subscription_tier.dart';
import '../data/repositories/subscription_repository.dart';

class SubscriptionService {
  final ISubscriptionRepository _subscriptionRepository;

  SubscriptionService({ISubscriptionRepository? subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository ?? SubscriptionRepository();

  Future<bool> checkFeatureAccess(String feature) async {
    try {
      return await _subscriptionRepository.checkSubscriptionAccess(feature);
    } catch (e) {
      return false;
    }
  }

  Future<Subscription?> getCurrentSubscription() async {
    try {
      return await _subscriptionRepository.getCurrentSubscription();
    } catch (e) {
      return null;
    }
  }

  Future<void> createSubscriptionForUser(User user) async {
    await _subscriptionRepository.createSubscriptionForUser(user);
  }

  Future<void> initializeExistingUsersSubscriptions() async {
    await _subscriptionRepository.initializeExistingUsersSubscriptions();
  }

  Future<void> cancelSubscription() async {
    await _subscriptionRepository.cancelSubscription();
  }

  Future<List<Subscription>> getSubscriptionHistory() async {
    return await _subscriptionRepository.getSubscriptionHistory();
  }

  Future<void> updateSubscription(Subscription subscription) async {
    await _subscriptionRepository.updateSubscription(subscription);
  }
}
