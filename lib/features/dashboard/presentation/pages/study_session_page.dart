import 'package:flutter/material.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/services/spaced_repetition_service.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:hugeicons/hugeicons.dart';
import '../widgets/flashcard.dart';

class StudySessionPage extends StatefulWidget {
  final List<SavedWord> words;

  const StudySessionPage({
    super.key,
    required this.words,
  });

  @override
  State<StudySessionPage> createState() => _StudySessionPageState();
}

class _StudySessionPageState extends State<StudySessionPage> {
  final _spacedRepetitionService = SpacedRepetitionService();
  int _currentIndex = 0;
  late final FlipCardController _flipCardController;

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
  }

  Future<void> _markWord(int difficulty) async {
    final currentWord = widget.words[_currentIndex];
    
    try {
      // Calculate next review using spaced repetition
      final updatedWord = _spacedRepetitionService.calculateNextReview(
        currentWord,
        difficulty,
      );

      // Log word state before update
      Logger.log('Word before update:');
      Logger.log('ID: ${currentWord.id}');
      Logger.log('Word: ${currentWord.word}');
      Logger.log('Current progress: ${currentWord.progress}');
      Logger.log('Current difficulty: ${currentWord.difficulty}');
      
      Logger.log('Word after spaced repetition calculation:');
      Logger.log('New progress: ${updatedWord.progress}');
      Logger.log('New difficulty: ${updatedWord.difficulty}');
      Logger.log('New interval: ${updatedWord.interval}');
      Logger.log('New ease factor: ${updatedWord.easeFactor}');

      // Update word in repository
      final savedWordsRepo = context.read<SavedWordsRepository>();
      await savedWordsRepo.updateWord(updatedWord);
      
      final nextReview = _spacedRepetitionService.getNextReviewDate(updatedWord);
      Logger.log('Successfully updated word: ${updatedWord.word}');
      Logger.log('Next review in ${updatedWord.interval} days ($nextReview)');

      // Move to next word or end session
      if (_currentIndex + 1 < widget.words.length) {
        setState(() {
          _currentIndex++;
        });
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      Logger.error('Failed to update word', error: e, stackTrace: StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(UiTranslations.of(context).translate('flashcard_error_update')),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _markWord(difficulty),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${UiTranslations.of(context).translate('flashcard_study_session')} (${_currentIndex + 1}/${widget.words.length})',
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.words.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

          // Current flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Flashcard(
                word: widget.words[_currentIndex].word,
                definition: widget.words[_currentIndex].definition,
                examples: widget.words[_currentIndex].examples,
                language: widget.words[_currentIndex].language,
                controller: _flipCardController,
              ),
            ),
          ),

          // Difficulty buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDifficultyButton(
                  0,
                  'flashcard_difficulty_hard',
                  AppColors.flashcardHardLight,
                  AppColors.flashcardHardDark,
                ),
                _buildDifficultyButton(
                  1,
                  'flashcard_difficulty_good',
                  AppColors.flashcardGoodLight,
                  AppColors.flashcardGoodDark,
                ),
                _buildDifficultyButton(
                  2,
                  'flashcard_difficulty_easy',
                  AppColors.flashcardEasyLight,
                  AppColors.flashcardEasyDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(
    int difficulty,
    String labelKey,
    Color lightColor,
    Color darkColor,
  ) {
    return ElevatedButton(
      onPressed: () => _markWord(difficulty),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? lightColor
            : darkColor,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white.withOpacity(0.87)
            : Colors.white,
      ),
      child: Text(UiTranslations.of(context).translate(labelKey)),
    );
  }
}
