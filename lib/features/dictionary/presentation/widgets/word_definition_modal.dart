import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/features/dictionary/presentation/entry_points/show_japanese_modal.dart';

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
    // For Japanese words, use the enhanced Japanese modal with Jisho support
    if (language.code == 'ja') {
      return showJapaneseModal(context, word, language);
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
  String? _meaningsTitle;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initializeServices();
    }
  }

  @override
  void dispose() {
    _dictionaryService.close();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      Logger.log('Initializing services for word: ${widget.word}');
      
      // First ensure dictionary service is initialized
      if (!_dictionaryService.isInitialized) {
        Logger.log('Dictionary service not initialized, initializing now...');
        await _dictionaryService.initialize();
      }
      
      // Get definition
      _definition = await _dictionaryService.getDefinition(
        widget.word,
        widget.language,
        context,
      );

      // Check if word is saved
      _isSaved = await _savedWordsRepository.isWordSaved(widget.word);

      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      Logger.error('Error initializing services', error: e);
      setState(() {
        _isLoading = false;
        _error = 'Failed to load definition: $e';
      });
    }
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
        context,
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
          Logger.error('Word definition modal error', error: e);
          _error = e.toString();
        });
      }
    }
  }

  String? _loadingMessage;

  Widget _buildLoadingState() {
    // Initialize loading message if not already set
    if (_loadingMessage == null) {
      final translations = UiTranslations.of(context);
      _loadingMessage = translations
          .translate('finding_examples')
          .replaceAll('{0}', widget.word);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoadingAnimation(size: 80),
        const SizedBox(height: 16),
        Text(
          _loadingMessage!,
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

  Widget _buildCloseButton(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
        child: IconButton(
          icon: Icon(
            Icons.close,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.word,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
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
                              _dictionaryService.speakWord(
                                  widget.word, widget.language.code, context);
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: _toggleSaveWord,
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
                if (_definition?['reading'] != null &&
                    _definition!['reading'].isNotEmpty)
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

  Widget _buildDefinitions() {
    if (_definition == null || _definition!.isEmpty) {
      return const Center(child: Text('No definition found'));
    }

    final meanings = _definition!['meanings'] as List<dynamic>? ?? [];
    final uiLanguageMeanings = _definition!['ui_language_meanings'] as List<dynamic>? ?? [];
    final currentUiLanguage = UiTranslations.of(context).currentLanguage;

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (meanings.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...meanings.map((meaning) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $meaning'),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (uiLanguageMeanings.isNotEmpty && widget.language.code != currentUiLanguage) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...uiLanguageMeanings.map((meaning) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $meaning'),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEtymologySection(ThemeData theme) {
    if (_definition?['etymology'] == null ||
        _definition!['etymology'].isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(child: Text(_error!))
          else
            _buildDefinitions(),
        ],
      ),
    );
  }
}
