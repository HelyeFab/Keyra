import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_page.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/word_definition_modal.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart' show tokenize;
import 'package:Keyra/core/widgets/loading_animation.dart';
import 'package:Keyra/features/books/presentation/bloc/tts_bloc.dart';
import 'package:Keyra/features/books/data/repositories/book_repository.dart';
import 'package:Keyra/features/common/presentation/utils/connectivity_utils.dart';
import 'package:Keyra/features/subscription/data/repositories/subscription_repository.dart';
import 'package:Keyra/features/subscription/domain/entities/subscription_helper.dart';
import 'package:Keyra/features/subscription/presentation/widgets/book_limit_dialog.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/sentence_translation_modal.dart';
import 'package:Keyra/features/dictionary/data/services/translation_service.dart';
import 'package:Keyra/core/ui_language/bloc/ui_language_bloc.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

// Model for word reading
class WordReading {
  final String word;
  final String? reading;
  final String? sentenceText;
  final bool isTranslateIcon;

  const WordReading(this.word, this.reading,
      [this.sentenceText, this.isTranslateIcon = false]);
}

class BookReaderPage extends StatefulWidget {
  final Book book;
  final BookLanguage language;
  final UserStatsRepository userStatsRepository;
  final DictionaryService dictionaryService;
  final BookRepository bookRepository;
  final TranslationService translationService;

  const BookReaderPage({
    super.key,
    required this.book,
    required this.language,
    required this.userStatsRepository,
    required this.dictionaryService,
    required this.bookRepository,
    required this.translationService,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late PageController _pageController;
  int _currentPage = 0;
  final bool _hasMarkedAsRead = false;
  final bool _isLoading = false;
  double _textScale = 1.0;
  static const double _baseFontSize = 20.0;
  late final TTSBloc _ttsBloc;
  final _subscriptionRepository = SubscriptionRepository();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ttsBloc = TTSBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSubscriptionAndStart();
    });
  }

  Future<void> _checkSubscriptionAndStart() async {
    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }

      // Check subscription limit first
      final subscription =
          await _subscriptionRepository.getCurrentSubscription();
      if (subscription == null) return;

      // Check if user can read more books based on their subscription tier
      if (!subscription.canReadBooks) {
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => BookLimitDialog(
            currentBooks: subscription.booksRead,
            bookLimit: subscription.bookLimit,
            nextIncreaseDate: subscription.nextLimitIncrease,
          ),
        );
        // Pop back to previous screen since we can't read more books
        if (!mounted) return;
        Navigator.of(context).pop();
        return;
      }

      // If we haven't reached the limit, start reading
      await _startReadingSession();
    } catch (e) {
      debugPrint('Error checking subscription: $e');
    }
  }

  Future<void> _startReadingSession() async {
    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }

      // Start reading session for stats
      await widget.userStatsRepository.startReadingSession();

      // Update book progress in Firestore
      final updatedBook = widget.book.copyWith(
        currentPage: _currentPage,
        lastReadAt: DateTime.now(),
        currentLanguage: widget.language,
      );
      debugPrint('BookReaderPage: Language code: ${widget.language.code}');

      debugPrint('BookReaderPage: Starting reading session');
      debugPrint('BookReaderPage: Current page: $_currentPage');
      debugPrint('BookReaderPage: Language: ${widget.language.code}');

      try {
        await widget.bookRepository.updateBook(updatedBook);
        debugPrint('BookReaderPage: Reading session started successfully');
      } catch (e) {
        debugPrint('BookReaderPage: Error starting reading session: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('Error starting reading session: $e');
    }
  }

  Future<void> _endReadingSession() async {
    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }
      await widget.userStatsRepository.endReadingSession();
    } catch (e) {
      debugPrint('Error ending reading session: $e');
    }
  }

  Future<void> _onPageChanged(int page) async {
    setState(() {
      _currentPage = page;
    });

    // Stop TTS when changing pages
    _ttsBloc.add(TTSStopRequested());

    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }

      // Update book progress in Firestore
      final updatedBook = widget.book.copyWith(
        currentPage: page,
        lastReadAt: DateTime.now(),
        currentLanguage: widget.language,
      );
      debugPrint('BookReaderPage: Language code: ${widget.language.code}');

      debugPrint('BookReaderPage: Updating progress');
      debugPrint('BookReaderPage: Current page: $page');
      debugPrint('BookReaderPage: Total pages: ${widget.book.pages.length}');
      debugPrint('BookReaderPage: Language: ${widget.language.code}');

      try {
        await widget.bookRepository.updateBook(updatedBook);
        debugPrint('BookReaderPage: Progress updated successfully');
      } catch (e) {
        debugPrint('BookReaderPage: Error updating progress: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('Error updating book progress: $e');
    }
  }

  Widget _buildFontSizeButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDecrease,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.black.withOpacity(0.7),
              size: 24.0,
            ),
            onPressed: onPressed,
            tooltip: isDecrease ? 'Decrease text size' : 'Increase text size',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _ttsBloc,
      child: WillPopScope(
        onWillPop: () async {
          _ttsBloc.add(TTSStopRequested());
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: [
              // Book content
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.book.pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(context, widget.book.pages[index]);
                },
              ),

              // Bottom navigation
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        '${_currentPage + 1} / ${widget.book.pages.length}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top controls
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: SafeArea(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.15),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: IconButton(
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedArrowLeft01,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.black.withOpacity(0.7),
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    _endReadingSession();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        _buildFontSizeButton(
                          icon: Icons.text_decrease,
                          onPressed: () {
                            setState(() {
                              _textScale = (_textScale - 0.1).clamp(0.8, 2.0);
                            });
                          },
                          isDecrease: true,
                        ),
                        _buildFontSizeButton(
                          icon: Icons.text_increase,
                          onPressed: () {
                            setState(() {
                              _textScale = (_textScale + 0.1).clamp(0.8, 2.0);
                            });
                          },
                          isDecrease: false,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, BookPage page) {
    final screenHeight = MediaQuery.of(context).size.height;
    final text = page.getText(widget.language);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Scrollable text content
          ListView(
            children: [
              // Space for image
              SizedBox(height: screenHeight * 0.45),
              // Text content
              if (text.isNotEmpty)
                Padding(
                  padding: AppSpacing.paddingMd,
                  child: Column(
                    children: [
                      _buildTextContent(context, text),
                      const SizedBox(
                          height: 100), // Bottom padding for scrolling
                    ],
                  ),
                ),
            ],
          ),

          // Fixed image section with audio player
          if (page.imagePath != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.5,
              child: Material(
                elevation: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        page.imagePath!,
                        fit: BoxFit.cover,
                        cacheWidth: 1080,
                        cacheHeight: 1080,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading image: $error');
                          return Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Center(
                              child:
                                  Icon(Icons.broken_image_outlined, size: 48),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: LoadingAnimation(size: 100),
                          );
                        },
                      ),
                    ),
                    if (page.getAudioPath(widget.language) != null) ...[
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 16,
                        child: _buildAudioPlayer(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Top controls
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: SafeArea(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: IconButton(
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowLeft01,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                _endReadingSession();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildFontSizeButton(
                      icon: Icons.text_decrease,
                      onPressed: () {
                        setState(() {
                          _textScale = (_textScale - 0.1).clamp(0.8, 2.0);
                        });
                      },
                      isDecrease: true,
                    ),
                    _buildFontSizeButton(
                      icon: Icons.text_increase,
                      onPressed: () {
                        setState(() {
                          _textScale = (_textScale + 0.1).clamp(0.8, 2.0);
                        });
                      },
                      isDecrease: false,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<WordReading>> _processJapaneseText(String text) async {
    try {
      final tokens = tokenize(text);
      final List<WordReading> results = [];

      // Track current sentence
      var currentSentence = StringBuffer();

      for (var token in tokens) {
        final word = token.toString();

        // Skip whitespace
        if (word.trim().isEmpty) {
          results.add(const WordReading(' ', null));
          continue;
        }

        // Add word to current sentence
        currentSentence.write(word);

        // Handle full stops with line breaks and add translate icon
        if (word == "。") {
          final sentenceText = currentSentence.toString();
          results.add(WordReading("。", null, sentenceText));
          results.add(const WordReading(" ", null)); // Space before icon
          results
              .add(WordReading("", null, sentenceText, true)); // Translate icon
          results.add(const WordReading(
              "\n", null)); // Single line break after each sentence
          // Reset sentence buffer
          currentSentence.clear();
          continue;
        }

        // Handle other punctuation and symbols directly
        if (RegExp(r'[、！？「」『』（）・〜…]').hasMatch(word)) {
          results.add(WordReading(word, null, currentSentence.toString()));
          continue;
        }

        // Add the word with current sentence, with line break at start of sentence
        if (currentSentence.isEmpty) {
          // Add line break at start of new sentence (except for first sentence)
          if (results.isNotEmpty) {
            results.add(const WordReading("\n", null));
          }
        }
        results.add(WordReading(word, null, currentSentence.toString()));
      }

      return results;
    } catch (e) {
      debugPrint('Error processing Japanese text: $e');
      return [WordReading(text, null)];
    }
  }

  Future<List<WordReading>> _processNonJapaneseText(String text) async {
    final List<WordReading> results = [];

    // Split text into sentences first
    final sentences = text.split(RegExp(r'([.!?])\s+'));

    for (var i = 0; i < sentences.length; i++) {
      var sentence = sentences[i];
      if (i < sentences.length - 1) {
        // Add back the punctuation that was removed by split
        sentence += text.substring(
          text.indexOf(sentence) + sentence.length,
          text.indexOf(sentence) + sentence.length + 1,
        );
      }

      // Skip empty sentences
      if (sentence.trim().isEmpty) continue;

      // Split sentence into words while preserving punctuation and spaces
      final pattern = RegExp(r'(\s+|[^\s\p{L}]+|\p{L}+)', unicode: true);
      final matches = pattern.allMatches(sentence);

      // Track current sentence text
      var currentSentence = StringBuffer();

      for (var match in matches) {
        final word = match.group(0)!;
        currentSentence.write(word);

        // Add the word with sentence context
        results.add(WordReading(word, null, currentSentence.toString()));
      }

      // Add translation icon and line break after each sentence
      results.add(const WordReading(" ", null)); // Space before icon
      results.add(WordReading(
          "", null, currentSentence.toString(), true)); // Translate icon
      results.add(const WordReading("\n", null)); // Line break after sentence
    }

    return results;
  }

  Widget _buildTextContent(BuildContext context, String content) {
    final theme = Theme.of(context);
    return FutureBuilder<List<WordReading>>(
      future: widget.language.code == 'ja'
          ? _processJapaneseText(content)
          : _processNonJapaneseText(content),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingAnimation(size: 50);
        }

        // Group words into sentences
        List<List<WordReading>> sentences = [];
        List<WordReading> currentSentence = [];

        for (var wordReading in snapshot.data!) {
          currentSentence.add(wordReading);
          if (wordReading.word == "\n") {
            if (currentSentence.isNotEmpty) {
              sentences.add(List.from(currentSentence));
              currentSentence = [];
            }
          }
        }

        if (currentSentence.isNotEmpty) {
          sentences.add(currentSentence);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sentences.map((sentence) {
            final textSpans = <InlineSpan>[];

            for (var wordReading in sentence) {
              if (wordReading.word == "\n") continue;

              if (wordReading.word.trim().isEmpty &&
                  !wordReading.isTranslateIcon) {
                textSpans.add(const TextSpan(text: ' '));
                continue;
              }

              if (wordReading.isTranslateIcon) {
                textSpans.add(
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () async {
                        if (!await ConnectivityUtils.checkConnectivity(
                            context)) {
                          return;
                        }
                        if (context.mounted &&
                            wordReading.sentenceText != null) {
                          try {
                            // Get UI language from bloc
                            final uiLanguageBloc =
                                context.read<UiLanguageBloc>();
                            final targetLanguage =
                                uiLanguageBloc.state.languageCode;

                            if (widget.language.code != targetLanguage) {
                              // Only translate and show translation card if languages are different
                              final translation =
                                  await widget.translationService.translateText(
                                wordReading.sentenceText!,
                                widget.language,
                                targetLanguage: targetLanguage,
                              );

                              if (context.mounted) {
                                SentenceTranslationModal.show(
                                  context,
                                  wordReading.sentenceText!,
                                  translation,
                                  widget.language,
                                  widget.dictionaryService,
                                );
                              }
                            } else {
                              // If languages are the same, show only original text without translation section
                              if (context.mounted) {
                                SentenceTranslationModal.show(
                                  context,
                                  wordReading.sentenceText!,
                                  UiTranslations.of(context).translate('no_translation_needed'),
                                  widget.language,
                                  widget.dictionaryService,
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('Failed to translate sentence: $e');
                          }
                        }
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple[100],
                        ),
                        child: const Icon(
                          Icons.translate,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                textSpans.add(
                  TextSpan(
                    text: wordReading.word,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        debugPrint('Tapped word: ${wordReading.word}');
                        if (!await ConnectivityUtils.checkConnectivity(
                            context)) {
                          return;
                        }
                        if (context.mounted) {
                          WordDefinitionModal.show(
                            context,
                            wordReading.word,
                            widget.language,
                          );
                        }
                      },
                  ),
                );
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SelectableText.rich(
                TextSpan(children: textSpans),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: _baseFontSize * _textScale,
                  fontFamily: widget.language.code == 'ja' ? null : 'Playwrite',
                  height: widget.language.code == 'ja'
                      ? AppSpacing.lineHeightLarge
                      : null,
                ),
                textAlign: TextAlign.left,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAudioPlayer() {
    return BlocBuilder<TTSBloc, TTSState>(
      bloc: _ttsBloc,
      builder: (context, state) {
        final currentPage = widget.book.pages[_currentPage];
        final audioPath = currentPage.getAudioPath(widget.language);
        final text = currentPage.getText(widget.language);

        if (audioPath == null || text.isEmpty) return const SizedBox.shrink();

        final isSlowSpeed = state.speedFactor < 1.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Speed control button
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSlowSpeed ? Icons.slow_motion_video : Icons.speed,
                      color: Colors.white.withOpacity(0.9),
                      size: 24.0,
                    ),
                    onPressed: () {
                      context.read<TTSBloc>().add(
                        TTSSpeedChanged(isSlowSpeed ? 1.0 : 0.7)
                      );
                    },
                    tooltip: isSlowSpeed ? 'Normal speed' : 'Slow speed (70%)',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Play/Pause button
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      state is TTSPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 24.0,
                    ),
                    onPressed: () {
                      if (state is TTSPlaying) {
                        context.read<TTSBloc>().add(TTSPauseRequested());
                      } else if (state is TTSPausedState) {
                        context.read<TTSBloc>().add(TTSResumeRequested());
                      } else {
                        context.read<TTSBloc>().add(
                          TTSStarted(text: text, language: widget.language),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _endReadingSession();
    _ttsBloc.add(TTSStopRequested());
    _ttsBloc.close();
    _pageController.dispose();
    super.dispose();
  }
}
