import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'subscription_enums.dart';
import 'subscription_json_converters.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const Subscription._();

  bool get canUseStudyFeature => 
    tier == SubscriptionTier.premium && 
    status == SubscriptionStatus.active;

  const factory Subscription({
    required String id,
    required String userId,
    @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
    required SubscriptionTier tier,
    @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
    required SubscriptionStatus status,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
    required DateTime startDate,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
    required DateTime endDate,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
    required DateTime lastLimitIncrease,
    String? paymentId,
    @Default(false) bool autoRenew,
    @Default(10) int bookLimit,
    @Default(0) int booksRead,
    @Default([]) List<String> readBookIds,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    return Subscription.fromJson(doc.data() as Map<String, dynamic>);
  }

  static Subscription get free => Subscription(
        id: 'free',
        userId: '',
        tier: SubscriptionTier.free,
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 36500)), // 100 years
        lastLimitIncrease: DateTime.now(),
        bookLimit: 10,
        booksRead: 0,
        readBookIds: [],
      );

  Map<String, dynamic> toMap() => toJson();
}
