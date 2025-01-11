import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/subscription.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState.initial() = _Initial;
  const factory SubscriptionState.loading() = _Loading;
  const factory SubscriptionState.loaded(Subscription subscription) = _Loaded;
  const factory SubscriptionState.error(String message) = _Error;
}
