import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final ISubscriptionRepository _repository;

  SubscriptionBloc({
    required ISubscriptionRepository repository,
  })  : _repository = repository,
        super(SubscriptionInitial()) {
    on<LoadCurrentSubscription>(_onLoadCurrentSubscription);
    on<UpdateSubscription>(_onUpdateSubscription);
    on<CancelSubscription>(_onCancelSubscription);
    on<LoadSubscriptionHistory>(_onLoadSubscriptionHistory);
    on<CheckSubscriptionAccess>(_onCheckSubscriptionAccess);
  }

  Future<void> _onLoadCurrentSubscription(
    LoadCurrentSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await _repository.getCurrentSubscription(event.userId);
    
    result.fold(
      (error) => emit(SubscriptionError(error.toString())),
      (subscription) => emit(SubscriptionLoaded(subscription)),
    );
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await _repository.updateSubscription(event.subscription);
    
    result.fold(
      (error) => emit(SubscriptionError(error.toString())),
      (subscription) => emit(SubscriptionLoaded(subscription)),
    );
  }

  Future<void> _onCancelSubscription(
    CancelSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await _repository.cancelSubscription(event.subscriptionId);
    
    result.fold(
      (error) => emit(SubscriptionError(error.toString())),
      (_) async {
        // After cancellation, reload the current subscription to show updated status
        final currentSubResult = await _repository.getCurrentSubscription(
          (state as SubscriptionLoaded).subscription.userId,
        );
        
        currentSubResult.fold(
          (error) => emit(SubscriptionError(error.toString())),
          (subscription) => emit(SubscriptionLoaded(subscription)),
        );
      },
    );
  }

  Future<void> _onLoadSubscriptionHistory(
    LoadSubscriptionHistory event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await _repository.getSubscriptionHistory(event.userId);
    
    result.fold(
      (error) => emit(SubscriptionError(error.toString())),
      (subscriptions) => emit(SubscriptionHistoryLoaded(subscriptions)),
    );
  }

  Future<void> _onCheckSubscriptionAccess(
    CheckSubscriptionAccess event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await _repository.checkSubscriptionAccess(
      event.userId,
      event.requiredTier,
    );
    
    result.fold(
      (error) => emit(SubscriptionError(error.toString())),
      (hasAccess) => emit(SubscriptionAccessChecked(
        hasAccess: hasAccess,
        requiredTier: event.requiredTier,
      )),
    );
  }
}
