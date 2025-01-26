import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_event.freezed.dart';

@freezed
class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.started() = _Started;
  const factory SubscriptionEvent.upgraded() = _Upgraded;
  const factory SubscriptionEvent.cancelled() = _Cancelled;
  const factory SubscriptionEvent.renewed() = _Renewed;
  const factory SubscriptionEvent.restored() = _Restored;
}
