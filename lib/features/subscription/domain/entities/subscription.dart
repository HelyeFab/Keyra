import 'package:cloud_firestore/cloud_firestore.dart';
import 'subscription_status.dart';
import 'subscription_tier.dart';

class Subscription {
  final String id;
  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final bool autoRenew;
  final DateTime createdAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.autoRenew,
    required this.createdAt,
  });

  bool get isActive => status.isActive;

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subscription(
      id: doc.id,
      userId: data['userId'] as String,
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.toString() == data['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      autoRenew: data['autoRenew'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tier': tier.toString(),
      'status': status.toString(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'autoRenew': autoRenew,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool hasAccess(String feature) {
    if (!isActive) return false;
    
    switch (feature) {
      case 'basic_reading':
        return true; // All tiers have access
      case 'offline_access':
        return tier == SubscriptionTier.premium || tier == SubscriptionTier.unlimited;
      case 'advanced_features':
        return tier == SubscriptionTier.unlimited;
      default:
        return false;
    }
  }

  Subscription copyWith({
    String? id,
    String? userId,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    DateTime? createdAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoRenew: autoRenew ?? this.autoRenew,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
