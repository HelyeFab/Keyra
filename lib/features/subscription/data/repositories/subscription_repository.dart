import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_enums.dart';
import '../../domain/repositories/i_subscription_repository.dart';
import '../services/purchase_handler.dart';

class SubscriptionRepository implements ISubscriptionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final PurchaseHandler _purchaseHandler;

  SubscriptionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    PurchaseHandler? purchaseHandler,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _purchaseHandler = purchaseHandler ?? PurchaseHandler(
          onError: (message) => print('Purchase error: $message'),
          onPending: () => print('Purchase pending'),
          onPurchaseVerified: (details) async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('subscriptions')
                  .doc(user.uid)
                  .update({
                'status': 'active',
                'tier': 'premium',
                'startDate': FieldValue.serverTimestamp(),
                'endDate': DateTime.now().add(const Duration(days: 30)),
                'paymentId': details.purchaseID,
              });
            }
          },
        );

  Future<void> initializePurchases() async {
    try {
      await _purchaseHandler.initialize();
    } catch (e) {
      print('Error initializing purchases: $e');
    }
  }

  Future<User?> _waitForAuthentication() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Wait briefly for auth state to be determined
      await Future.delayed(const Duration(milliseconds: 500));
      user = _auth.currentUser;
    }
    return user;
  }

  @override
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        print('User not authenticated, returning free subscription');
        return Subscription.free;
      }

      final querySnapshot = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No subscription found for user ${user.uid}');
        final freeSubscription = Subscription.free.copyWith(userId: user.uid);
        await createSubscriptionForUser(user.uid); // Create initial subscription
        return freeSubscription;
      }

      final doc = querySnapshot.docs.first;
      if (!doc.exists) {
        print('No subscription document exists, creating free subscription');
        final freeSubscription = Subscription.free.copyWith(userId: user.uid);
        await createSubscriptionForUser(user.uid);
        return freeSubscription;
      }

      final subscription = Subscription.fromFirestore(doc);
      print('Current subscription: tier=${subscription.tier}, status=${subscription.status}');
      return subscription;
    } catch (e) {
      print('Error getting subscription: $e');
      return Subscription.free;
    }
  }

  @override
  Future<List<Subscription>> getSubscriptionHistory() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        return [];
      }

      final snapshot = await _firestore
          .collection('subscriptions')
          .doc(user.uid)
          .collection('history')
          .orderBy('startDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Subscription.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting subscription history: $e');
      return [];
    }
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('subscriptions')
          .doc(user.uid)
          .set(subscription.toMap());
    } catch (e) {
      print('Error updating subscription: $e');
      throw Exception('Failed to update subscription: $e');
    }
  }

  @override
  Future<void> createSubscriptionForUser(String userId) async {
    try {
      final freeSubscription = Subscription.free.copyWith(userId: userId);
      await _firestore
          .collection('subscriptions')
          .doc(userId)
          .set(freeSubscription.toMap());
      print('Created free subscription for user $userId');
    } catch (e) {
      print('Error creating subscription: $e');
      throw Exception('Failed to create subscription: $e');
    }
  }

  @override
  Future<bool> checkSubscriptionAccess(String feature) async {
    try {
      final subscription = await getCurrentSubscription();
      final hasAccess = subscription?.hasAccess ?? false;
      print('Subscription access check: $feature = $hasAccess');
      return hasAccess;
    } catch (e) {
      print('Error checking subscription access: $e');
      return false;
    }
  }

  Future<Subscription> upgradeSubscription() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final currentSubscription = await getCurrentSubscription();
      if (currentSubscription == null) {
        throw Exception('No subscription found');
      }

      await _purchaseHandler.buySubscription(PurchaseHandler.monthlySubscriptionId);
      return currentSubscription;
    } catch (e) {
      print('Error upgrading subscription: $e');
      throw Exception('Failed to upgrade subscription: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _purchaseHandler.restorePurchases();
    } catch (e) {
      print('Error restoring purchases: $e');
      throw Exception('Failed to restore purchases: $e');
    }
  }

  Future<Subscription> renewSubscription() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final currentSubscription = await getCurrentSubscription();
      if (currentSubscription == null) {
        throw Exception('No subscription found');
      }

      final renewedSubscription = currentSubscription.copyWith(
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      await updateSubscription(renewedSubscription);
      return renewedSubscription;
    } catch (e) {
      print('Error renewing subscription: $e');
      throw Exception('Failed to renew subscription: $e');
    }
  }

  @override
  Future<Subscription> cancelSubscription() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final subscription = await getCurrentSubscription();
      if (subscription == null) {
        throw Exception('No subscription found');
      }

      if (subscription.tier == SubscriptionTier.free) {
        throw Exception('Cannot cancel a free subscription');
      }

      final cancelledSubscription = subscription.copyWith(
        status: SubscriptionStatus.cancelled,
      );

      await updateSubscription(cancelledSubscription);
      return cancelledSubscription;
    } catch (e) {
      print('Error cancelling subscription: $e');
      throw Exception('Failed to cancel subscription: $e');
    }
  }
}
