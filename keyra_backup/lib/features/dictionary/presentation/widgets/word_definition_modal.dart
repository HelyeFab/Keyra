import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/core/config/app_strings.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';
import 'japanese_word_definition_modal.dart';

class WordDefinitionModal extends StatefulWidget {
  final String word;
  final BookLanguage language;

  const WordDefinitionModal({
    super.key,
    required this.word,
    required this.language,
  });

  static Future<void> show(
    BuildContext context,
    String word,
    BookLanguage language,
  ) {
    // For Japanese words, use the Japanese-specific modal
    if (language.code == 'ja') {
      return JapaneseWordDefinitionModal.show(context, word, language);
    }

    final height = MediaQuery.of(context).size.height * 0.6;
    
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: WordDefinitionModal(
            word: word,
            language: language,
          ),
        ),
      ),
    );
  }

  @override
  State<WordDefinitionModal> createState() => _WordDefinitionModalState();
}

class _WordDefinitionModalState extends State<WordDefinitionModal> {
  final DictionaryService _dictionaryService = DictionaryService();
  final SavedWordsRepository _savedWordsRepository = SavedWordsRepository();
  Map<String, dynamic>? _definition;
  bool _isLoading = true;
  final bool _isSaving = false;
  bool _isSaved = false;
  String? _error;
  String? _savedWordId;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkIfWordIsSaved();
  }

  Future<void> _checkIfWordIsSaved() async {
    try {
      final isSaved = await _savedWordsRepository.isWordSaved(widget.word);
      if (isSaved) {
        final savedWords = await _savedWordsRepository.getSavedWords().first;
        final savedWord = savedWords.firstWhere(
          (word) => word.word.toLowerCase() == widget.word.toLowerCase(),
          orElse: () => SavedWord(
            id: '',
            word: '',
            definition: '',
            language: '',
            examples: [],
            savedAt: DateTime.now(),
          ),
        );
        
        if (mounted && savedWord.id.isNotEmpty) {
          setState(() {
            _isSaved = true;
            _savedWordId = savedWord.id;
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking if word is saved: $e');
    }
  }

  Future<void> _toggleSaveWord() async {
    if (_definition == null) return;

    setState(() {
      _isSaved = !_isSaved;
    });

    if (_isSaved) {
      try {
        String definition = '';
        final meanings = _definition!['meanings'] as List<dynamic>?;
        
        if (meanings != null && meanings.isNotEmpty) {
          if (widget.language.code == 'en') {
            // For English, take up to 6 meanings
            definition = meanings.take(6).map((m) => '• $m').join('\n');
          } else {
            definition = meanings.join('\n');
          }
        }

        final savedWord = SavedWord(
          id: const Uuid().v4(),
          word: widget.word,
          definition: definition,
          language: widget.language.code,
          examples: [],
          savedAt: DateTime.now(),
        );

        await _savedWordsRepository.saveWord(savedWord);
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSaved = false;
          });
        }
      }
    } else {
      await _savedWordsRepository.removeWord(widget.word);
    }
  }

  Future<void> _loadDefinition() async {
    try {
      final definition = await _dictionaryService.getDefinition(
        widget.word,
        widget.language,
      );
      if (mounted) {
        setState(() {
          _definition = definition;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _definition = null;
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoadingAnimation(size: 80),
        const SizedBox(height: 16),
        Text(
          AppStrings.findingExamplesFor(widget.word),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.word,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedVolumeMute01,
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.onSurface
                                : Colors.black,
                            size: 24.0,
                          ),
                          onPressed: () {
                            DictionaryService().speakWord(widget.word, widget.language.code);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: _toggleSaveWord,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.onSurface,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_definition?['partsOfSpeech'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      (_definition!['partsOfSpeech'] as List).join(', '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (_definition?['reading'] != null && _definition!['reading'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "/${_definition!['reading']}/",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningsSection(ThemeData theme) {
    if (_definition?['meanings'] == null || (_definition!['meanings'] as List).isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UiTranslations.of(context).translate('meanings'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ...(_definition!['meanings'] as List)
              .take(6)
              .map((meaning) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                        Expanded(
                          child: Text(
                            meaning.toString(),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ))
              ,
        ],
      ),
    );
  }

  Widget _buildEtymologySection(ThemeData theme) {
    if (_definition?['etymology'] == null || _definition!['etymology'].isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Etymology',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _definition!['etymology'],
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          _buildMeaningsSection(theme),
          _buildEtymologySection(theme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return _buildContent();
  }
}
