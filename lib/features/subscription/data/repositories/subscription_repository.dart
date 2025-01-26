import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_enums.dart';
import '../../domain/entities/subscription_helper.dart';
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
        _purchaseHandler = purchaseHandler ??
            PurchaseHandler(
              onError: (message) => Logger.error('Purchase error', error: message),
              onPending: () => Logger.log('Purchase pending'),
              onPurchaseVerified: (details) async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('subscriptions')
                      .doc(user.uid)  // Always use user.uid as document ID
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
      Logger.error('Failed to initialize purchases', error: e);
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

  Future<int> _getUserStatsBookCount(String userId) async {
    try {
      final statsDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('current')
          .get();
      
      if (!statsDoc.exists) return 0;
      
      final data = statsDoc.data();
      return data?['booksRead'] as int? ?? 0;
    } catch (e) {
      Logger.error('Failed to get user stats book count', error: e);
      return 0;
    }
  }

  @override
  Future<Subscription?> getSubscription(String userId) async {
    try {
      final doc = await _firestore
          .collection('subscriptions')
          .doc(userId)  // Use userId directly as document ID
          .get();

      if (!doc.exists) {
        return Subscription.free.copyWith(userId: userId);
      }

      return Subscription.fromFirestore(doc);
    } catch (e) {
      Logger.error('Failed to get subscription', error: e);
      return Subscription.free;
    }
  }

  @override
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        return Subscription.free;
      }

      final doc = await _firestore
          .collection('subscriptions')
          .doc(user.uid)  // Always use user.uid as document ID
          .get();

      if (!doc.exists) {
        Logger.log('No subscription found for user ${user.uid}');
        final freeSubscription = Subscription.free.copyWith(userId: user.uid);
        await createSubscriptionForUser(user.uid);
        return freeSubscription;
      }

      final subscription = Subscription.fromFirestore(doc);
      
      // Check if we should increase the book limit
      if (subscription.shouldIncreaseLimitToday) {
        Logger.log('Increasing book limit for subscription');
        final updatedSubscription = subscription.incrementBookLimit();
        await updateSubscription(updatedSubscription);
        return updatedSubscription;
      }

      Logger.log('Current subscription: tier=${subscription.tier}, status=${subscription.status}');
      return subscription;
    } catch (e) {
      Logger.error('Failed to get subscription', error: e);
      return Subscription.free;
    }
  }

  Future<void> incrementBooksRead(String bookId) async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      Logger.log('[SubscriptionRepository] Starting incrementBooksRead');
      
      // Use a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('subscriptions').doc(user.uid);
        final docSnap = await transaction.get(docRef);
        
        if (!docSnap.exists) {
          throw Exception('No subscription found');
        }
        
        final subscription = Subscription.fromFirestore(docSnap);
        
        // Only update if we haven't read this book before
        if (!subscription.hasReadBook(bookId)) {
          Logger.log('[SubscriptionRepository] Updating subscription for new book');
          
          // Get current stats count
          final statsBookCount = await _getUserStatsBookCount(user.uid);
          Logger.log('[SubscriptionRepository] Current stats book count: $statsBookCount');
          
          // Update subscription with stats count
          var updatedSubscription = subscription.copyWith(booksRead: statsBookCount);
          
          // Check if we should increase limit
          if (updatedSubscription.shouldIncreaseLimitToday) {
            updatedSubscription = updatedSubscription.incrementBookLimit();
          }
          
          // Update subscription document
          transaction.set(docRef, {
            'booksRead': statsBookCount,
            'bookLimit': updatedSubscription.bookLimit,
            'lastLimitIncrease': updatedSubscription.lastLimitIncrease,
            'readBookIds': FieldValue.arrayUnion([bookId]),
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } else {
          Logger.log('[SubscriptionRepository] Book already read, not updating subscription');
        }
      });
    } catch (e) {
      Logger.error('Failed to increment books read', error: e, throwError: true);
      throw Exception('Failed to increment books read: $e');
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
          .doc(user.uid)  // Always use user.uid
          .collection('history')
          .orderBy('startDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Subscription.fromFirestore(doc))
          .toList();
    } catch (e) {
      Logger.error('Failed to get subscription history', error: e);
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

      final data = subscription.toMap();
      data['lastUpdated'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('subscriptions')
          .doc(user.uid)  // Always use user.uid
          .set(data);

      // Force a refresh
      await Future.delayed(const Duration(milliseconds: 100));
      await _firestore
          .collection('subscriptions')
          .doc(user.uid)
          .set({
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      Logger.error('Failed to update subscription', error: e, throwError: true);
      throw Exception('Failed to update subscription: $e');
    }
  }

  Future<void> updateCurrentSubscription(Subscription subscription) async {
    try {
      final user = await _waitForAuthentication();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await updateSubscription(subscription);
    } catch (e) {
      Logger.error('Failed to update subscription', error: e, throwError: true);
      throw Exception('Failed to update subscription: $e');
    }
  }

  @override
  Future<void> createSubscriptionForUser(String userId) async {
    try {
      final freeSubscription = Subscription.free.copyWith(userId: userId);
      final data = freeSubscription.toMap();
      data['lastUpdated'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('subscriptions')
          .doc(userId)  // Use userId directly as document ID
          .set(data);
      Logger.log('Created free subscription for user $userId');
    } catch (e) {
      Logger.error('Failed to create subscription', error: e, throwError: true);
      throw Exception('Failed to create subscription: $e');
    }
  }

  @override
  Future<bool> checkSubscriptionAccess(String feature) async {
    try {
      final subscription = await getCurrentSubscription();
      final hasAccess = subscription?.hasAccess ?? false;
      Logger.log('Subscription access check: $feature = $hasAccess');
      return hasAccess;
    } catch (e) {
      Logger.error('Failed to check subscription access', error: e);
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
      Logger.error('Failed to upgrade subscription', error: e, throwError: true);
      throw Exception('Failed to upgrade subscription: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _purchaseHandler.restorePurchases();
    } catch (e) {
      Logger.error('Failed to restore purchases', error: e, throwError: true);
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

      await updateCurrentSubscription(renewedSubscription);
      return renewedSubscription;
    } catch (e) {
      Logger.error('Failed to renew subscription', error: e, throwError: true);
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

      await updateCurrentSubscription(cancelledSubscription);
      return cancelledSubscription;
    } catch (e) {
      Logger.error('Failed to cancel subscription', error: e, throwError: true);
      throw Exception('Failed to cancel subscription: $e');
    }
  }
}
