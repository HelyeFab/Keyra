import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final Subscription subscription;

  const SubscriptionLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubscriptionHistoryLoaded extends SubscriptionState {
  final List<Subscription> subscriptions;

  const SubscriptionHistoryLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionAccessChecked extends SubscriptionState {
  final bool hasAccess;
  final SubscriptionTier requiredTier;

  const SubscriptionAccessChecked({
    required this.hasAccess,
    required this.requiredTier,
  });

  @override
  List<Object?> get props => [hasAccess, requiredTier];
}
