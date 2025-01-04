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

class BookReaderPage extends StatefulWidget {
  final Book book;
  final BookLanguage language;
  final UserStatsRepository userStatsRepository;
  final DictionaryService dictionaryService;
  final BookRepository bookRepository;

  const BookReaderPage({
    super.key,
    required this.book,
    required this.language,
    required this.userStatsRepository,
    required this.dictionaryService,
    required this.bookRepository,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _hasMarkedAsRead = false;
  final bool _isLoading = false;
  double _textScale = 1.0;
  static const double _baseFontSize = 20.0;
  late final TTSBloc _ttsBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ttsBloc = TTSBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startReadingSession();
    });
  }

  Future<void> _startReadingSession() async {
    try {
      // Start reading session for stats
      await widget.userStatsRepository.startReadingSession();
      
      // Update book progress in Firestore
      final updatedBook = widget.book.copyWith(
        currentPage: _currentPage,
        lastReadAt: DateTime.now(),
        currentLanguage: widget.language,
      );
      print('BookReaderPage: Language code: ${widget.language.code}');
      
      print('BookReaderPage: Starting reading session');
      print('BookReaderPage: Current page: $_currentPage');
      print('BookReaderPage: Language: ${widget.language.code}');
      
      try {
        await widget.bookRepository.updateBook(updatedBook);
        print('BookReaderPage: Reading session started successfully');
      } catch (e) {
        print('BookReaderPage: Error starting reading session: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('Error starting reading session: $e');
    }
  }

  Future<void> _endReadingSession() async {
    try {
      await widget.userStatsRepository.endReadingSession();
    } catch (e) {
      debugPrint('Error ending reading session: $e');
    }
  }

  Future<void> _markBookAsRead() async {
    if (!_hasMarkedAsRead) {
      try {
        await widget.userStatsRepository.markBookAsRead();
        _hasMarkedAsRead = true;
      } catch (e) {
        debugPrint('Error marking book as read: $e');
      }
    }
  }

  Future<void> _onPageChanged(int page) async {
    setState(() {
      _currentPage = page;
    });

    try {
      // Update book progress in Firestore
      final updatedBook = widget.book.copyWith(
        currentPage: page,
        lastReadAt: DateTime.now(),
        currentLanguage: widget.language,
      );
      print('BookReaderPage: Language code: ${widget.language.code}');
      
      print('BookReaderPage: Updating progress');
      print('BookReaderPage: Current page: $page');
      print('BookReaderPage: Total pages: ${widget.book.pages.length}');
      print('BookReaderPage: Language: ${widget.language.code}');
      
      try {
        await widget.bookRepository.updateBook(updatedBook);
        print('BookReaderPage: Progress updated successfully');
      } catch (e) {
        print('BookReaderPage: Error updating progress: $e');
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.readerControlDark
            : AppColors.readerControl,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.controlTextDark
              : AppColors.controlText,
          size: 24.0,
        ),
        onPressed: onPressed,
        tooltip: isDecrease ? 'Decrease text size' : 'Increase text size',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.readerControlDark
                              : AppColors.readerControl,
                        ),
                        child: IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft01,
                            color: AppColors.controlText,
                            size: 24.0,
                          ),
                          onPressed: _currentPage > 0
                              ? () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_currentPage + 1} / ${widget.book.pages.length}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.controlTextDark
                              : AppColors.controlText,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.readerControlDark
                              : AppColors.readerControl,
                        ),
                        child: IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            color: AppColors.controlText,
                            size: 24.0,
                          ),
                          onPressed: _currentPage < widget.book.pages.length - 1
                              ? () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                        ),
                      ),
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
    
    return Stack(
      children: [
        // Text content with space for image
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.5), // Space for image
              if (text.isNotEmpty)
                Padding(
                  padding: AppSpacing.paddingMd,
                  child: _buildTextContent(context, text),
                ),
              if (page.getAudioPath(widget.language) != null)
                Padding(
                  padding: AppSpacing.paddingVerticalMd,
                  child: _buildAudioPlayer(),
                ),
            ],
          ),
        ),
        
        // Image taking up half the screen
        if (page.imagePath != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Image.network(
              page.imagePath!,
              fit: BoxFit.cover,
              cacheWidth: 1080, // Full screen width for high quality
              cacheHeight: 1080,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading image: $error');
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
        
        // Controls overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.readerControlDark
                          : AppColors.readerControl,
                    ),
                    child: IconButton(
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        color: AppColors.controlText,
                        size: 24.0,
                      ),
                      onPressed: () {
                        _endReadingSession();
                        Navigator.of(context).pop();
                      },
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
    );
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

        final wordsWithReadings = snapshot.data!;
        final textSpans = <InlineSpan>[];
        
        for (var wordReading in wordsWithReadings) {
          if (wordReading.word.trim().isEmpty) {
            textSpans.add(const TextSpan(text: ' '));
            continue;
          }
          
          textSpans.add(
            TextSpan(
              text: wordReading.word,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint('Tapped word: ${wordReading.word}');
                  WordDefinitionModal.show(
                    context,
                    wordReading.word,
                    widget.language,
                  );
                },
            ),
          );
        }

        return SelectableText.rich(
          TextSpan(children: textSpans),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: theme.textTheme.bodyMedium!.fontSize! * _textScale,
          ),
          textAlign: TextAlign.justify,
        );
      },
    );
  }

  Future<List<WordReading>> _processJapaneseText(String text) async {
    try {
      final tokens = tokenize(text);
      final List<WordReading> results = [];
      
      for (var token in tokens) {
        final word = token.toString();
        
        // Skip whitespace
        if (word.trim().isEmpty) {
          results.add(WordReading(' ', null));
          continue;
        }

        // Handle punctuation and symbols directly
        if (RegExp(r'[。、！？「」『』（）・〜…]').hasMatch(word)) {
          results.add(WordReading(word, null));
          continue;
        }

        // Add the word
        results.add(WordReading(word, null));
      }
      
      return results;
    } catch (e) {
      debugPrint('Error processing Japanese text: $e');
      return [WordReading(text, null)];
    }
  }

  Future<List<WordReading>> _processNonJapaneseText(String text) async {
    final List<WordReading> results = [];
    
    // Split text into words while preserving punctuation and spaces
    final pattern = RegExp(r'(\s+|[^\s\p{L}]+|\p{L}+)', unicode: true);
    final matches = pattern.allMatches(text);
    
    for (var match in matches) {
      final word = match.group(0)!;
      
      // Add the word or punctuation
      results.add(WordReading(word, null));
    }
    
    return results;
  }

  Widget _buildAudioPlayer() {
    return BlocBuilder<TTSBloc, TTSState>(
      bloc: _ttsBloc,
      builder: (context, state) {
        final currentPage = widget.book.pages[_currentPage];
        final pageText = currentPage.getText(widget.language);
        final buttonColor = Theme.of(context).brightness == Brightness.dark
            ? AppColors.readerControlDark
            : AppColors.readerControl;

        if (state is TTSPlaying) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: buttonColor,
          ),
          child: IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedPause,
              color: AppColors.controlText,
              size: 24.0,
            ),
            iconSize: 48,
            onPressed: () {
              _ttsBloc.add(TTSPauseRequested());
            },
          ),
        ),
      );
        } else {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: buttonColor,
          ),
          child: IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedPlay,
              color: AppColors.controlText,
              size: 24.0,
            ),
            iconSize: 48,
            onPressed: () {
              _ttsBloc.add(TTSStarted(
                text: pageText,
                language: widget.language,
              ));
            },
          ),
        ),
      );
        }
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
