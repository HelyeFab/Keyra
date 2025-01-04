import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_progress.dart';
import '../../domain/models/badge_requirements.dart';
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
        wordsUpdated: (e) async => await _onWordsUpdated(e.wordCount, emit),
        levelUp: (e) async => await _onLevelUp(e.newLevel, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<BadgeState> emit) async {
    try {
      // Try to get initial stats
      final stats = await _userStatsRepository.getUserStats();
      if (!emit.isDone) {
        final progress = BadgeProgress(
          currentLevel: _calculateBadgeLevel(stats),
          booksRead: stats.booksRead,
          favoriteBooks: stats.favoriteBooks,
          readingStreak: stats.readingStreak,
          lastUpdated: DateTime.now(),
        );
        emit(BadgeState.loaded(progress));
      }

      // Set up subscription only after successful initial load
      await _statsSubscription?.cancel(); // Cancel any existing subscription
      _statsSubscription = _userStatsRepository.streamUserStats().listen(
        (stats) {
          if (!isClosed) {
            add(BadgeEvent.wordsUpdated(stats.savedWords));
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

  Future<void> _onWordsUpdated(int wordCount, Emitter<BadgeState> emit) async {
    try {
      final stats = await _userStatsRepository.getUserStats();
      final progress = BadgeProgress(
        currentLevel: _calculateBadgeLevel(stats),
        booksRead: stats.booksRead,
        favoriteBooks: stats.favoriteBooks,
        readingStreak: stats.readingStreak,
        lastUpdated: DateTime.now(),
      );
      emit(BadgeState.loaded(progress));
    } catch (e) {
      print('Error updating badge stats: $e');
    }
  }

  Future<void> _onLevelUp(
    BadgeLevel newLevel,
    Emitter<BadgeState> emit,
  ) async {
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

      if (!emit.isDone) {
        emit(BadgeState.levelingUp(currentProgress, newLevel));
      }

      // Reset to loaded state after showing level up
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

    // Check each level from highest to lowest
    final masterReqs = BadgeRequirements.getRequirementsForLevel(BadgeLevel.master);
    if (masterReqs.isSatisfiedBy(
      booksRead: stats.booksRead,
      favoriteBooks: stats.favoriteBooks,
      readingStreak: stats.readingStreak,
    )) {
      return BadgeLevel.master;
    }

    final advancedReqs = BadgeRequirements.getRequirementsForLevel(BadgeLevel.advanced);
    if (advancedReqs.isSatisfiedBy(
      booksRead: stats.booksRead,
      favoriteBooks: stats.favoriteBooks,
      readingStreak: stats.readingStreak,
    )) {
      return BadgeLevel.advanced;
    }

    final intermediateReqs = BadgeRequirements.getRequirementsForLevel(BadgeLevel.intermediate);
    if (intermediateReqs.isSatisfiedBy(
      booksRead: stats.booksRead,
      favoriteBooks: stats.favoriteBooks,
      readingStreak: stats.readingStreak,
    )) {
      return BadgeLevel.intermediate;
    }

    return BadgeLevel.beginner;
  }

  @override
  Future<void> close() async {
    await _progressSubscription?.cancel();
    await _statsSubscription?.cancel();
    return super.close();
  }
}
