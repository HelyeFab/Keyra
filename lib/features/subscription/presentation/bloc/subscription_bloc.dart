import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/entities/subscription_enums.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionBloc({
    required SubscriptionRepository subscriptionRepository,
  })  : _subscriptionRepository = subscriptionRepository,
        super(const SubscriptionState.initial()) {
    on<SubscriptionEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        upgraded: () => _onUpgraded(emit),
        cancelled: () => _onCancelled(emit),
        renewed: () => _onRenewed(emit),
        restored: () => _onRestored(emit),
      );
    });
    // Initialize purchases when bloc is created
    _subscriptionRepository.initializePurchases();
  }

  Future<void> _onStarted(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      final subscription = await _subscriptionRepository.getCurrentSubscription();
      if (subscription != null) {
        // Verify subscription status
        final isActive = await _subscriptionRepository.checkSubscriptionAccess('premium');
        if (!isActive && subscription.tier == SubscriptionTier.premium) {
          emit(const SubscriptionState.error('Subscription validation failed'));
          return;
        }
        emit(SubscriptionState.loaded(subscription));
      } else {
        emit(const SubscriptionState.error('No subscription found'));
      }
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }

  Future<void> _onUpgraded(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      final subscription = await _subscriptionRepository.upgradeSubscription();
      
      // Verify subscription status after upgrade
      final isActive = await _subscriptionRepository.checkSubscriptionAccess('premium');
      if (!isActive) {
        emit(const SubscriptionState.error('Failed to verify subscription status'));
        return;
      }
      
      emit(SubscriptionState.loaded(subscription));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }

  Future<void> _onCancelled(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      final subscription = await _subscriptionRepository.cancelSubscription();
      emit(SubscriptionState.loaded(subscription));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }

  Future<void> _onRenewed(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      final subscription = await _subscriptionRepository.renewSubscription();
      
      // Verify subscription status after renewal
      final isActive = await _subscriptionRepository.checkSubscriptionAccess('premium');
      if (!isActive) {
        emit(const SubscriptionState.error('Failed to verify subscription renewal'));
        return;
      }
      
      emit(SubscriptionState.loaded(subscription));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }

  Future<void> _onRestored(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      await _subscriptionRepository.restorePurchases();
      final subscription = await _subscriptionRepository.getCurrentSubscription();
      
      if (subscription != null) {
        // Verify restored subscription status
        final isActive = await _subscriptionRepository.checkSubscriptionAccess('premium');
        if (!isActive && subscription.tier == SubscriptionTier.premium) {
          emit(const SubscriptionState.error('Failed to verify restored subscription'));
          return;
        }
        emit(SubscriptionState.loaded(subscription));
      } else {
        emit(const SubscriptionState.error('No subscription found'));
      }
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
}
