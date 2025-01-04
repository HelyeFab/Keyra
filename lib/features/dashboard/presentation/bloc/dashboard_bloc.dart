import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/user_stats_repository.dart';
import '../../domain/models/user_stats.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserStatsRepository _userStatsRepository;
  StreamSubscription<UserStats>? _statsSubscription;
  StreamSubscription<User?>? _authSubscription;

  DashboardBloc({
    required UserStatsRepository userStatsRepository,
  })  : _userStatsRepository = userStatsRepository,
        super(const DashboardState.initial()) {
    on<_LoadDashboardStats>(_onLoadDashboardStats);

    // Listen to auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          print('[DashboardBloc] Auth state changed - user logged in');
          // Only load stats when we have a confirmed authenticated user
          add(const DashboardEvent.loadDashboardStats());
        } else {
          print('[DashboardBloc] Auth state changed - user logged out');
          emit(const DashboardState.error('Not authenticated'));
        }
      },
      onError: (error) {
        print('[DashboardBloc] Auth state error: $error');
        emit(DashboardState.error(error.toString()));
      },
    );

    // Set up the stats stream subscription immediately
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('[DashboardBloc] Setting up initial stats stream');
      _statsSubscription = _userStatsRepository.streamUserStats().listen(
        (stats) {
          print('[DashboardBloc] Received stats update from stream: $stats');
          if (!isClosed) {
            emit(DashboardState.loaded(
              booksRead: stats.booksRead,
              favoriteBooks: stats.favoriteBooks,
              readingStreak: stats.readingStreak,
              savedWords: stats.savedWords,
            ));
          }
        },
        onError: (error) {
          print('[DashboardBloc] Error in stats stream: $error');
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
    print('[DashboardBloc] Loading dashboard stats');
    emit(const DashboardState.loading());

    try {
      // Get initial stats
      final freshStats = await _userStatsRepository.getUserStats();
      print('[DashboardBloc] Got fresh stats: $freshStats');
      
      if (!isClosed) {
        emit(DashboardState.loaded(
          booksRead: freshStats.booksRead,
          favoriteBooks: freshStats.favoriteBooks,
          readingStreak: freshStats.readingStreak,
          savedWords: freshStats.savedWords,
        ));
      }
    } catch (error) {
      print('[DashboardBloc] Error loading stats: $error');
      if (!isClosed) {
        emit(DashboardState.error(error.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    print('[DashboardBloc] Closing bloc');
    await _statsSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
