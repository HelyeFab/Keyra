import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/i_subscription_repository.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_status.dart';

class SubscriptionRepository implements ISubscriptionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String _baseUrl = 'https://us-central1-keyra-93667.cloudfunctions.net';

  SubscriptionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> createSubscriptionForUser(User user) async {
    try {
      final idToken = await user.getIdToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/createUserSubscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: '{"user": {"uid": "${user.uid}"}}',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create subscription: $e');
    }
  }

  @override
  Future<void> initializeExistingUsersSubscriptions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final idToken = await user.getIdToken();
      final response = await http.post(
        Uri.parse('https://initializeexistinguserssubscriptions-tm4vwb7zjq-uc.a.run.app'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to initialize subscriptions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to initialize subscriptions: $e');
    }
  }

  @override
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final subscriptionSnapshot = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (subscriptionSnapshot.docs.isEmpty) return null;

      return Subscription.fromFirestore(subscriptionSnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get current subscription: $e');
    }
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      await _firestore
          .collection('subscriptions')
          .doc(subscription.id)
          .update(subscription.toMap());
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  @override
  Future<void> cancelSubscription() async {
    try {
      final currentSubscription = await getCurrentSubscription();
      if (currentSubscription == null) {
        throw Exception('No active subscription found');
      }

      final updatedSubscription = currentSubscription.copyWith(
        status: SubscriptionStatus.cancelled,
        autoRenew: false,
      );

      await updateSubscription(updatedSubscription);
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  @override
  Future<List<Subscription>> getSubscriptionHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final subscriptionsSnapshot = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return subscriptionsSnapshot.docs
          .map((doc) => Subscription.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get subscription history: $e');
    }
  }

  @override
  Future<bool> checkSubscriptionAccess(String feature) async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) return false;
      return subscription.hasAccess(feature);
    } catch (e) {
      throw Exception('Failed to check subscription access: $e');
    }
  }
}
