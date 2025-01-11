import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/subscription_repository.dart';
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
      );
    });
  }

  Future<void> _onStarted(Emitter<SubscriptionState> emit) async {
    try {
      emit(const SubscriptionState.loading());
      final subscription = await _subscriptionRepository.getCurrentSubscription();
      if (subscription != null) {
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
      emit(SubscriptionState.loaded(subscription));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }
}
