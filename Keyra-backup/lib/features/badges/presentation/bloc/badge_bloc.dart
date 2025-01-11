import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_progress.dart';
import '../../domain/models/badge_requirements.dart';
import '../../domain/models/badge_requirements_config.dart';
import '../../domain/repositories/badge_repository.dart';
import '../../../dashboard/data/repositories/user_stats_repository.dart';
import '../../../dashboard/domain/models/user_stats.dart';
import '../../../dictionary/data/repositories/saved_words_repository.dart';
import '../../../dictionary/domain/models/saved_word.dart';
import 'badge_event.dart';
import 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _badgeRepository;
  final SavedWordsRepository _savedWordsRepository;
  final UserStatsRepository _userStatsRepository;
  StreamSubscription<List<SavedWord>>? _progressSubscription;
  StreamSubscription<UserStats>? _statsSubscription;

  BadgeBloc({
    required BadgeRepository badgeRepository,
    required SavedWordsRepository savedWordsRepository,
    required UserStatsRepository userStatsRepository,
  })  : _badgeRepository = badgeRepository,
        _savedWordsRepository = savedWordsRepository,
        _userStatsRepository = userStatsRepository,
        super(const BadgeState.initial()) {
    on<BadgeEvent>((event, emit) async {
      await event.map(
        started: (_) async => await _onStarted(emit),
        wordsUpdated: (e) async => await _onStatsUpdated(await _userStatsRepository.getUserStats(), emit),
        levelUp: (e) async => await _onLevelUp(e.newLevel, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<BadgeState> emit) async {
    try {
      // Try to get initial stats
      final stats = await _userStatsRepository.getUserStats();
      await _onStatsUpdated(stats, emit);

      // Set up subscription only after successful initial load
      await _statsSubscription?.cancel(); // Cancel any existing subscription
      _statsSubscription = _userStatsRepository.streamUserStats().listen(
        (stats) {
          if (!isClosed) {
            add(BadgeEvent.wordsUpdated(stats.savedWords)); // Pass saved words count
          }
        },
        onError: (error) {
          print('Error in badge stats stream: $error');
        },
      );
    } catch (e) {
      // Keep initial state if we can't load stats (e.g. user not authenticated)
      print('Could not load badge stats: $e');
    }
  }

  Future<void> _onStatsUpdated(UserStats stats, Emitter<BadgeState> emit) async {
    if (emit.isDone) return;
    
    try {
      print('[BadgeBloc] Processing stats update:');
      print('[BadgeBloc] Books read: ${stats.booksRead}');
      print('[BadgeBloc] Favorite books: ${stats.favoriteBooks}');
      print('[BadgeBloc] Reading streak: ${stats.readingStreak}');
      
      final newLevel = _calculateBadgeLevel(stats);
      print('[BadgeBloc] Calculated badge level: $newLevel');
      
      final currentState = state;
      final currentLevel = currentState.map(
        initial: (_) => BadgeLevel.beginner,
        loaded: (s) => s.progress.currentLevel,
        levelingUp: (s) => s.progress.currentLevel,
      );
      
      final progress = BadgeProgress(
        currentLevel: newLevel,
        booksRead: stats.booksRead,
        favoriteBooks: stats.favoriteBooks,
        readingStreak: stats.readingStreak,
        lastUpdated: DateTime.now(),
      );
      
      if (newLevel != currentLevel) {
        print('[BadgeBloc] Badge level changed from $currentLevel to $newLevel');
        emit(BadgeState.levelingUp(progress, newLevel));
        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed && !emit.isDone) {
          emit(BadgeState.loaded(progress));
        }
      } else {
        print('[BadgeBloc] Updating progress with same level: $newLevel');
        emit(BadgeState.loaded(progress));
      }
    } catch (e) {
      print('[BadgeBloc] Error updating badge progress: $e');
    }
  }

  Future<void> _onLevelUp(
    BadgeLevel newLevel,
    Emitter<BadgeState> emit,
  ) async {
    if (emit.isDone) return;
    
    try {
      final currentState = state;
      if (!currentState.map(
        initial: (_) => false,
        loaded: (_) => true,
        levelingUp: (_) => true,
      )) {
        return;
      }

      final currentProgress = currentState.map(
        initial: (_) => BadgeProgress(
          currentLevel: BadgeLevel.beginner,
          booksRead: 0,
          favoriteBooks: 0,
          readingStreak: 0,
          lastUpdated: DateTime.now(),
        ),
        loaded: (s) => s.progress,
        levelingUp: (s) => s.progress,
      );

      emit(BadgeState.levelingUp(currentProgress, newLevel));
      await Future.delayed(const Duration(seconds: 2));
      if (!emit.isDone) {
        final updatedProgress = currentProgress.copyWith(currentLevel: newLevel);
        emit(BadgeState.loaded(updatedProgress));
      }
    } catch (e) {
      print('Error in level up: $e');
    }
  }

  BadgeLevel _calculateBadgeLevel(UserStats stats) {
    print('\n[BadgeBloc] Calculating badge level for stats: $stats');
    
    // Check each level from highest to lowest
    final levels = BadgeLevel.values.toList()
      ..sort((a, b) => badgeRequirementsConfig[b]!.requiredBooksRead
          .compareTo(badgeRequirementsConfig[a]!.requiredBooksRead));
    
    print('[BadgeBloc] Checking levels in order: ${levels.join(', ')}');

    for (final level in levels) {
      final requirements = BadgeRequirements.getRequirementsForLevel(level);
      print('\n[BadgeBloc] Checking requirements for level: $level');
      print('[BadgeBloc] Requirements: $requirements');
      
      if (requirements.isSatisfiedBy(
        booksRead: stats.booksRead,
        favoriteBooks: stats.favoriteBooks,
        readingStreak: stats.readingStreak,
      )) {
        print('[BadgeBloc] Found matching level: $level');
        return level;
      }
    }

    print('[BadgeBloc] No matching level found, defaulting to beginner');
    return BadgeLevel.beginner;
  }

  @override
  Future<void> close() async {
    await _progressSubscription?.cancel();
    await _statsSubscription?.cancel();
    return super.close();
  }
}
