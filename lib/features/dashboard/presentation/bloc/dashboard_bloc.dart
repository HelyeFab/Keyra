import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/user_stats_repository.dart';
import '../../domain/models/user_stats.dart';
import '../../../subscription/data/repositories/subscription_repository.dart';
import '../../../subscription/domain/entities/subscription_enums.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserStatsRepository _userStatsRepository;
  final SubscriptionRepository _subscriptionRepository;
  StreamSubscription<UserStats>? _statsSubscription;
  StreamSubscription<User?>? _authSubscription;

  DashboardBloc({
    required UserStatsRepository userStatsRepository,
  })  : _userStatsRepository = userStatsRepository,
        _subscriptionRepository = SubscriptionRepository(),
        super(const DashboardState.initial()) {
    on<_LoadDashboardStats>(_onLoadDashboardStats);

    // Listen to auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          // Only load stats when we have a confirmed authenticated user
          add(const DashboardEvent.loadDashboardStats());
        } else {
          emit(const DashboardState.error('Not authenticated'));
        }
      },
      onError: (error) {
        emit(DashboardState.error(error.toString()));
      },
    );

    // Set up the stats stream subscription immediately
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _statsSubscription = _userStatsRepository.streamUserStats().listen(
        (stats) async {
          if (!isClosed) {
            // Get subscription info
            final subscription = await _subscriptionRepository.getCurrentSubscription();
            final isPremium = subscription?.tier == SubscriptionTier.premium;
            final bookLimit = isPremium ? null : subscription?.bookLimit;

            emit(DashboardState.loaded(
              booksRead: stats.booksRead,
              favoriteBooks: stats.favoriteBooks,
              readingStreak: stats.readingStreak,
              savedWords: stats.savedWords,
              isPremium: isPremium,
              bookLimit: bookLimit,
            ));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(DashboardState.error(error.toString()));
          }
        },
      );
    }
  }

  void loadDashboardStats() {
    add(const DashboardEvent.loadDashboardStats());
  }

  void _onLoadDashboardStats(
    _LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());

    try {
      // Get initial stats
      final freshStats = await _userStatsRepository.getUserStats();
      
      // Get subscription info
      final subscription = await _subscriptionRepository.getCurrentSubscription();
      final isPremium = subscription?.tier == SubscriptionTier.premium;
      final bookLimit = isPremium ? null : subscription?.bookLimit;
      
      if (!isClosed) {
        emit(DashboardState.loaded(
          booksRead: freshStats.booksRead,
          favoriteBooks: freshStats.favoriteBooks,
          readingStreak: freshStats.readingStreak,
          savedWords: freshStats.savedWords,
          isPremium: isPremium,
          bookLimit: bookLimit,
        ));
      }
    } catch (error) {
      if (!isClosed) {
        emit(DashboardState.error(error.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _statsSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
