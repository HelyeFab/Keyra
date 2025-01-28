import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_page.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/utils/logger.dart';
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
  bool _showFurigana = false;

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
      Logger.error('Error checking subscription: $e');
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

      try {
        await widget.bookRepository.updateBook(updatedBook);
      } catch (e) {
        Logger.error('Error starting reading session: $e');
        rethrow;
      }
    } catch (e) {
      Logger.error('Error starting reading session: $e');
    }
  }

  Future<void> _endReadingSession() async {
    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }
      await widget.userStatsRepository.endReadingSession();
    } catch (e) {
      Logger.error('Error ending reading session: $e');
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

      try {
        await widget.bookRepository.updateBook(updatedBook);
      } catch (e) {
        Logger.error('Error updating book progress: $e');
        rethrow;
      }
    } catch (e) {
      Logger.error('Error updating book progress: $e');
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
          body: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.book.pages.length,
            itemBuilder: (context, index) {
              return _buildPage(context, widget.book.pages[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, BookPage page) {
    final screenHeight = MediaQuery.of(context).size.height;
    final text = page.getText(widget.language.code);
    // Get furigana text if Japanese and furigana mode is on
    final String displayText = widget.language.code == 'ja' && _showFurigana 
        ? page.getText('ja_furigana')
        : text;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Space for image and some extra padding
                SizedBox(height: screenHeight * 0.5 + 20), 
                // Text content
                if (displayText.isNotEmpty)
                  Padding(
                    padding: AppSpacing.paddingMd,
                    child: Column(
                      children: [
                        _buildTextContent(context, displayText),
                        const SizedBox(height: 100), // Bottom padding for scrolling
                      ],
                    ),
                  ),
              ],
            ),
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
                          Logger.error('Error loading image: $error');
                          return Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.broken_image_outlined, size: 48),
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

                    if (page.getAudioPath(widget.language.code) != null) ...[
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
                    // Add Furigana toggle button for Japanese text
                    if (widget.language.code == 'ja')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                icon: Icon(
                                  _showFurigana ? Icons.subtitles : Icons.subtitles_off,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.7),
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showFurigana = !_showFurigana;
                                  });
                                },
                                tooltip: _showFurigana ? 'Hide furigana' : 'Show furigana',
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildTextContent(BuildContext context, String content) {
    final theme = Theme.of(context);
    
    // Only use Japanese text processing when furigana is enabled
    if (widget.language.code == 'ja' && _showFurigana) {
      return FutureBuilder<List<WordReading>>(
        future: _processJapaneseText(content),
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
              final List<InlineSpan> spans = [];
              String? currentSentenceText;

              for (var wordReading in sentence) {
                if (wordReading.word == "\n") continue;

                if (wordReading.isTranslateIcon && wordReading.sentenceText != null) {
                  currentSentenceText = wordReading.sentenceText;
                  spans.add(
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        onTap: () async {
                          if (!await ConnectivityUtils.checkConnectivity(context)) {
                            return;
                          }
                          try {
                            final uiLanguageBloc = context.read<UiLanguageBloc>();
                            final targetLanguage = uiLanguageBloc.state.languageCode;

                            if (widget.language.code != targetLanguage) {
                              final translation = await widget.translationService.translateText(
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
                            Logger.error('Failed to translate sentence: $e');
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
                  continue;
                }

                if (wordReading.reading != null) {
                  spans.add(
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          Logger.error('Tapped word: ${wordReading.word}');
                          if (!await ConnectivityUtils.checkConnectivity(context)) {
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
                        child: _showFurigana ? Stack(
                          alignment: Alignment.center,
                          children: [
                            // Base text container to maintain proper line spacing
                            Text(
                              wordReading.word,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: _baseFontSize * _textScale,
                                height: 2.0,
                                color: Colors.transparent, // Hidden but maintains space
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Furigana text (above)
                                Text(
                                  wordReading.reading!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: (_baseFontSize * 0.5) * _textScale,
                                    color: Colors.blue,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6), // Increased gap to 6 pixels
                                // Kanji text (below)
                                Text(
                                  wordReading.word,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: (_baseFontSize * 0.85) * _textScale,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ) : Text(
                          wordReading.word,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: _baseFontSize * _textScale,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  spans.add(TextSpan(
                    text: wordReading.word,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: _baseFontSize * _textScale,
                      height: _showFurigana ? 2.0 : null,
                    ),
                  ));
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SelectableText.rich(
                  TextSpan(children: spans),
                  textAlign: TextAlign.left,
                ),
              );
            }).toList(),
          );
        },
      );
    }

    // For Japanese without furigana or other languages
    return FutureBuilder<List<WordReading>>(
      future: _processNonJapaneseText(content),
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
                            Logger.error('Failed to translate sentence: $e');
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
                        Logger.error('Tapped word: ${wordReading.word}');
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: _baseFontSize * _textScale,
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

  Future<List<WordReading>> _processJapaneseText(String text) async {
    final List<WordReading> results = [];
    final List<String> sentences = text.split('。');
    final RegExp regex = RegExp(r'\[([^\]]+)\]\{([^\}]+)\}');

    for (String sentence in sentences) {
      if (sentence.trim().isEmpty) {
        results.add(const WordReading("\n", null));
        continue;
      }

      final StringBuffer currentSentence = StringBuffer();
      int lastEnd = 0;

      for (var match in regex.allMatches(sentence)) {
        // Add any text before this match
        if (match.start > lastEnd) {
          final plainText = sentence.substring(lastEnd, match.start);
          results.add(WordReading(plainText, null));
          currentSentence.write(plainText);
        }

        // Process the kanji-furigana pair
        final kanji = match.group(1)!;
        final furigana = match.group(2)!;
        
        // Add the word reading without any brackets
        results.add(WordReading(kanji, furigana));
        currentSentence.write(kanji);

        lastEnd = match.end;
      }

      // Add any remaining text
      if (lastEnd < sentence.length) {
        final remainingText = sentence.substring(lastEnd);
        results.add(WordReading(remainingText, null));
        currentSentence.write(remainingText);
      }

      // Add the full stop, translation icon, and line break after each sentence (except last empty one)
      if (currentSentence.isNotEmpty) {
        results.add(const WordReading("。", null));
        results.add(const WordReading(" ", null)); // Space before icon
        results.add(WordReading(
            "", null, "$currentSentence。", true)); // Translate icon with full stop
        results.add(const WordReading("\n", null)); // Line break after sentence
      }
    }

    return results;
  }

  Future<List<WordReading>> _processNonJapaneseText(String text) async {
    final List<WordReading> results = [];

    // For Japanese text, use tokenize
    if (widget.language.code == 'ja') {
      final sentences = text.split('。');
      for (var sentence in sentences) {
        if (sentence.trim().isEmpty) {
          results.add(const WordReading("\n", null));
          continue;
        }

        final tokens = tokenize(sentence);
        for (var token in tokens) {
          results.add(WordReading(token, null));
        }

        if (sentence.isNotEmpty) {
          results.add(const WordReading("。", null));
          results.add(const WordReading(" ", null)); // Space before icon
          results.add(WordReading("", null, "$sentence。", true)); // Translation icon
          results.add(const WordReading("\n", null));
        }
      }
      return results;
    }

    // For non-Japanese text, use the original processing
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

  Widget _buildAudioPlayer() {
    return BlocBuilder<TTSBloc, TTSState>(
      bloc: _ttsBloc,
      builder: (context, state) {
        final currentPage = widget.book.pages[_currentPage];
        final audioPath = currentPage.getAudioPath(widget.language.code);
        final text = currentPage.getText(widget.language.code);

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
                      state is TTSPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 24.0,
                    ),
                    onPressed: () {
                      if (state is TTSPlaying) {
                        context.read<TTSBloc>().add(TTSStopRequested());
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
