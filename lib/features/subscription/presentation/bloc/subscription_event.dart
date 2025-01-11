import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrentSubscription extends SubscriptionEvent {
  final String userId;

  const LoadCurrentSubscription(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateSubscription extends SubscriptionEvent {
  final Subscription subscription;

  const UpdateSubscription(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class CancelSubscription extends SubscriptionEvent {
  final String subscriptionId;

  const CancelSubscription(this.subscriptionId);

  @override
  List<Object?> get props => [subscriptionId];
}

class LoadSubscriptionHistory extends SubscriptionEvent {
  final String userId;

  const LoadSubscriptionHistory(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CheckSubscriptionAccess extends SubscriptionEvent {
  final String userId;
  final SubscriptionTier requiredTier;

  const CheckSubscriptionAccess({
    required this.userId,
    required this.requiredTier,
  });

  @override
  List<Object?> get props => [userId, requiredTier];
}
