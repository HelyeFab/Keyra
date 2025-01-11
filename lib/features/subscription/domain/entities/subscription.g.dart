// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tier: tierFromJson(json['tier'] as String),
      status: statusFromJson(json['status'] as String),
      startDate: dateTimeFromTimestamp(json['startDate'] as Timestamp),
      endDate: dateTimeFromTimestamp(json['endDate'] as Timestamp),
      paymentId: json['paymentId'] as String?,
      autoRenew: json['autoRenew'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tier': tierToJson(instance.tier),
      'status': statusToJson(instance.status),
      'startDate': dateTimeToTimestamp(instance.startDate),
      'endDate': dateTimeToTimestamp(instance.endDate),
      'paymentId': instance.paymentId,
      'autoRenew': instance.autoRenew,
    };
