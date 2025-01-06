 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card_controller.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../features/dictionary/domain/models/saved_word.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../features/dictionary/domain/services/spaced_repetition_service.dart';
import '../widgets/flashcard.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import 'package:hugeicons/hugeicons.dart';

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
  late final PageController _pageController;
  final _spacedRepetitionService = SpacedRepetitionService();
  int _currentIndex = 0;
  List<FlipCardController> _flipControllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize a flip controller for each word
    _flipControllers = List.generate(
      widget.words.length,
      (_) => FlipCardController(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _markWord(int difficulty) async {
    final currentWord = widget.words[_currentIndex];
    
    try {
      // Calculate next review using spaced repetition
      final updatedWord = _spacedRepetitionService.calculateNextReview(
        currentWord,
        difficulty,
      );

      // Update word in repository
      final savedWordsRepo = context.read<SavedWordsRepository>();
      await savedWordsRepo.updateWord(updatedWord);
      
      final nextReview = _spacedRepetitionService.getNextReviewDate(updatedWord);
      print('Successfully updated word: ${updatedWord.word}');
      print('Progress: ${updatedWord.progress}, Difficulty: ${updatedWord.difficulty}');
      print('Repetitions: ${updatedWord.repetitions}, Ease Factor: ${updatedWord.easeFactor.toStringAsFixed(2)}');
      print('Next review in ${updatedWord.interval} days ($nextReview)');

      // Move to next word
      final nextIndex = _currentIndex + 1;
      if (nextIndex < widget.words.length) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // End of session
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('Error updating word: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(UiTranslationService.translate(context, 'flashcard_error_update')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        final languageCode = uiLanguageState.languageCode;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Colors.black,
                size: 24.0,
              ),
            ),
            title: Text(
              '${UiTranslationService.translate(context, 'flashcard_study_session')} (${_currentIndex + 1}/${widget.words.length})',
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedShare01,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24.0,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: ((_currentIndex + 1) / widget.words.length),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),

              // Flashcards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.words.length,
                  itemBuilder: (context, index) {
                    final word = widget.words[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Flashcard(
                        word: word.word,
                        definition: word.definition,
                        examples: word.examples,
                        controller: _flipControllers[index],
                        language: word.language,
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _markWord(0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.light
                            ? AppColors.flashcardHardLight
                            : AppColors.flashcardHardDark,
                        foregroundColor: Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.87)
                            : Colors.white,
                      ),
                      child: Text(UiTranslationService.translate(context, 'flashcard_difficulty_hard')),
                    ),
                    ElevatedButton(
                      onPressed: () => _markWord(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.light
                            ? AppColors.flashcardGoodLight
                            : AppColors.flashcardGoodDark,
                        foregroundColor: Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.87)
                            : Colors.white,
                      ),
                      child: Text(UiTranslationService.translate(context, 'flashcard_difficulty_good')),
                    ),
                    ElevatedButton(
                      onPressed: () => _markWord(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.light
                            ? AppColors.flashcardEasyLight
                            : AppColors.flashcardEasyDark,
                        foregroundColor: Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.87)
                            : Colors.white,
                      ),
                      child: Text(UiTranslationService.translate(context, 'flashcard_difficulty_easy')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
