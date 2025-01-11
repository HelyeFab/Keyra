import 'package:cloud_firestore/cloud_firestore.dart';
import 'subscription_enums.dart';

SubscriptionTier tierFromJson(String value) {
  return SubscriptionTier.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => SubscriptionTier.free,
  );
}

String tierToJson(SubscriptionTier tier) {
  return tier.toString().split('.').last;
}

SubscriptionStatus statusFromJson(String value) {
  return SubscriptionStatus.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => SubscriptionStatus.inactive,
  );
}

String statusToJson(SubscriptionStatus status) {
  return status.toString().split('.').last;
}

DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return timestamp.toDate();
}

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

DateTime? nullableDateTimeFromTimestamp(Timestamp? timestamp) {
  return timestamp?.toDate();
}

Timestamp? nullableDateTimeToTimestamp(DateTime? dateTime) {
  return dateTime != null ? Timestamp.fromDate(dateTime) : null;
}
