import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_enums.dart';
import '../../domain/repositories/i_subscription_repository.dart';

class SubscriptionRepository implements ISubscriptionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SubscriptionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<Subscription?> getCurrentSubscription() async {
    final user = _auth.currentUser;
    if (user == null) {
      return Subscription.free;
    }

    try {
      final querySnapshot = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No subscription found for user ${user.uid}');
        return Subscription.free.copyWith(userId: user.uid);
      }

      final doc = querySnapshot.docs.first;

      print('Subscription Data from Firestore: ${doc.data()}');

      if (!doc.exists) {
        print('No subscription document exists, returning free subscription');
        return Subscription.free.copyWith(userId: user.uid);
      }

      final subscription = Subscription.fromFirestore(doc);
      print('Parsed Subscription: tier=${subscription.tier}, status=${subscription.status}');
      return subscription;
    } catch (e) {
      return Subscription.free.copyWith(userId: user.uid);
    }
  }

  @override
  Future<List<Subscription>> getSubscriptionHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
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
      return [];
    }
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('subscriptions')
        .doc(user.uid)
        .set(subscription.toMap());
  }

  @override
  Future<void> createSubscriptionForUser(String userId) async {
    final freeSubscription = Subscription.free.copyWith(userId: userId);
    await _firestore
        .collection('subscriptions')
        .doc(userId)
        .set(freeSubscription.toMap());
  }

  @override
  Future<bool> checkSubscriptionAccess(String feature) async {
    final subscription = await getCurrentSubscription();
    return subscription?.hasAccess ?? false;
  }

  // Additional methods needed by the SubscriptionBloc
  Future<Subscription> upgradeSubscription() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final currentSubscription = await getCurrentSubscription();
    if (currentSubscription == null) {
      throw Exception('No subscription found');
    }

    final upgradedSubscription = currentSubscription.copyWith(
      tier: SubscriptionTier.premium,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
    );

    await updateSubscription(upgradedSubscription);
    return upgradedSubscription;
  }

  Future<Subscription> renewSubscription() async {
    final user = _auth.currentUser;
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
  }

  @override
  Future<Subscription> cancelSubscription() async {
    final user = _auth.currentUser;
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
  }
}
