import 'package:firebase_auth/firebase_auth.dart';
import '../domain/repositories/i_subscription_repository.dart';

class SubscriptionService {
  final ISubscriptionRepository _subscriptionRepository;

  SubscriptionService({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  Future<void> createSubscriptionForUser(User user) async {
    await _subscriptionRepository.createSubscriptionForUser(user.uid);
  }

  Future<void> initializeSubscriptions() async {
    // This method can be used to initialize subscriptions for existing users
    // if needed in the future
  }
}
