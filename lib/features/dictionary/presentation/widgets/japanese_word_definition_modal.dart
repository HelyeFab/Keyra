import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';
import 'package:Keyra/features/dictionary/presentation/entry_points/show_japanese_modal.dart';

class JapaneseWordDefinitionModal extends StatefulWidget {
  final String word;
  final BookLanguage language;

  const JapaneseWordDefinitionModal({
    super.key,
    required this.word,
    required this.language,
  });

  @Deprecated('Use showJapaneseModal from show_japanese_modal.dart instead')
  static Future<void> show(
    BuildContext context,
    String word,
    BookLanguage language,
  ) {
    // Forward to the new enhanced modal
    return showJapaneseModal(context, word, language);
  }

  @override
  State<JapaneseWordDefinitionModal> createState() =>
      _JapaneseWordDefinitionModalState();
}

class _JapaneseWordDefinitionModalState
    extends State<JapaneseWordDefinitionModal> {
  final DictionaryService _dictionaryService = DictionaryService();
  final SavedWordsRepository _savedWordsRepository = SavedWordsRepository();
  Map<String, dynamic>? _definition;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSaved = false;
  String? _error;
  String? _savedWordId;
  String? _meaningsTitle;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _dictionaryService.stopSpeaking();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      Logger.log('Initializing dictionary service...');
      await _dictionaryService.initialize();

      if (!_dictionaryService.isInitialized) {
        throw Exception('Dictionary service failed to initialize');
      }
      Logger.log('Dictionary service initialized successfully');

      if (!mounted) return;
      final translations = UiTranslations.of(context);
      _meaningsTitle = translations.translate('meanings');
      _loadingMessage = translations
          .translate('finding_examples')
          .replaceAll('{0}', widget.word);

      if (!mounted) return;
      await _checkIfWordIsSaved().catchError((e) {
        debugPrint('Error checking saved status: $e');
        return null;
      });
      
      if (!mounted) return;
      await _loadDefinition();
    } catch (e) {
      Logger.error('Failed to initialize services', error: e);
      if (mounted) {
        setState(() {
          _error = e.toString().contains('Dictionary service')
              ? 'Failed to initialize dictionary services'
              : 'Error loading word definition';
          _isLoading = false;
        });
      }
    } finally {
      _isInitializing = false;
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
    if (_definition == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isSaved && _savedWordId != null) {
        await _savedWordsRepository.removeWord(_savedWordId!);
        setState(() {
          _isSaved = false;
          _savedWordId = null;
        });
      } else {
        String definition;
        final meanings = _definition!['jmdict_meanings'] as List<dynamic>?;

        if (meanings != null && meanings.isNotEmpty) {
          final firstMeaning = meanings.first;
          definition = '${firstMeaning['meaning']} (${_definition!['reading'] ?? ''})';
        } else {
          definition = 'No definition available';
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

        setState(() {
          _isSaved = true;
          _savedWordId = savedWord.id;
        });
      }
    } catch (e) {
      debugPrint('Error toggling word save state: $e');
      if (mounted) {
        final errorMessage = e.toString().contains('already saved')
            ? UiTranslations.of(context).translate('word_already_saved')
            : UiTranslations.of(context).translate('failed_to_update_word');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _loadDefinition() async {
    try {
      Logger.log('Loading definition for word: ${widget.word}');
      
      final definition = await _dictionaryService.getDefinition(
        widget.word,
        widget.language,
        context,
      );

      if (mounted) {
        if (definition.isEmpty ||
            (!definition.containsKey('jmdict_meanings') &&
             !definition.containsKey('kanji_info')) ||
            ((definition['jmdict_meanings'] as List?)?.isEmpty ?? true) &&
            ((definition['kanji_info'] as List?)?.isEmpty ?? true)) {
          setState(() {
            _definition = null;
            _isLoading = false;
            _error = 'Found 0 entries';
          });
        } else {
          setState(() {
            _definition = definition;
            _isLoading = false;
            _error = null;
          });
          Logger.log('Definition loaded successfully');
        }
      }
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to load definition',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _definition = null;
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  String? _loadingMessage;

  Widget _buildLoadingState() {
    final message = _loadingMessage ?? 'Loading...';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoadingAnimation(size: 80),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final isNoDefinition = _error?.contains('Found 0 entries') == true;
    final translations = UiTranslations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNoDefinition ? Icons.info_outline : Icons.error_outline,
              size: 48,
              color: isNoDefinition
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isNoDefinition
                  ? translations
                      .translate('no_definition_found')
                      .replaceAll('{0}', widget.word)
                  : (_error ?? 'An error occurred'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isNoDefinition
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.error,
              ),
            ),
            if (isNoDefinition) ...[
              const SizedBox(height: 8),
              Text(
                translations.translate('check_spelling'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_definition?['reading'] != null)
                    RubyText(
                      [
                        RubyTextData(
                          _definition!['base_word'] ?? widget.word,
                          ruby: _definition!['reading'],
                        ),
                        if (_definition?['particle'] != null)
                          RubyTextData(
                            _definition!['particle']['value'],
                            ruby: '',
                          ),
                      ],
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      rubyStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Text(
                      widget.word,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
              if (_definition?['parts_of_speech'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      (_definition!['parts_of_speech'] as List).join(', '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              if (_definition?['particle'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'Particle: ${_definition!['particle']['value']}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? theme.colorScheme.surfaceContainerHighest
                  : const Color(0xFFFFF9C4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? theme.colorScheme.primary : null,
              ),
              onPressed: _toggleSaveWord,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningsSection(
      ThemeData theme, String title, List<dynamic> meanings) {
    if (meanings.isEmpty) {
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
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ...meanings.map((meaning) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ',
                        style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant)),
                    Expanded(
                      child: Text(
                        meaning['meaning']?.toString() ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExamplesSection(
      ThemeData theme, List<Map<String, String>> examples) {
    if (examples.isEmpty) {
      return const SizedBox.shrink();
    }

    final translations = UiTranslations.of(context);
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
            translations.translate('expressions_subtitle'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ...examples.map((example) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RubyText(
                      [RubyTextData(example['japanese']!, ruby: '')],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example['english']!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildKanjiSection(
      ThemeData theme, String kanji, Map<String, dynamic> info) {
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
          Row(
            children: [
              Text(
                kanji,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  if (info['grade'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'Grade ${info['grade']}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  if (info['grade'] != null && info['jlpt'] != null)
                    const SizedBox(width: 8),
                  if (info['jlpt'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'JLPT N${info['jlpt']}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (info['meanings'] != null) ...[
            Text(
              'Meanings:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (info['meanings'] as List).join(', '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (info['readings'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Readings:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            if (info['readings'] is Map) ...[
              if ((info['readings'] as Map)['on']?.isNotEmpty ?? false) ...[
                Text(
                  'On: ${((info['readings'] as Map)['on'] as List).join(', ')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if ((info['readings'] as Map)['kun']?.isNotEmpty ?? false) ...[
                const SizedBox(height: 2),
                Text(
                  'Kun: ${((info['readings'] as Map)['kun'] as List).join(', ')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ] else if (info['readings'] is List) ...[
              Text(
                (info['readings'] as List).join(', '),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
          if (info['strokeCount'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Stroke count: ${info['strokeCount']}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllMeaningsSections(ThemeData theme) {
    final List<Widget> sections = [];
    final translations = UiTranslations.of(context);

    // Add JMDict meanings if available
    if (_definition?['jmdict_meanings'] != null) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'JMDict',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            _buildMeaningsSection(
              theme,
              translations.translate('meanings'),
              _definition!['jmdict_meanings'] as List,
            ),
          ],
        ),
      );
    }

    // Add Kanji information if available
    if (_definition?['kanji_info'] != null) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'KanjiDict',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ...(_definition!['kanji_info'] as List).map((kanji) => _buildKanjiSection(
              theme,
              kanji['literal'] as String,
              kanji as Map<String, dynamic>,
            )),
          ],
        ),
      );
    }

    // Add examples if available
    if (_definition?['examples'] != null) {
      sections.add(_buildExamplesSection(
        theme,
        (_definition!['examples'] as List).cast<Map<String, String>>(),
      ));
    }

    return Column(children: sections);
  }

  Widget _buildContent() {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        _buildAllMeaningsSections(theme),
      ],
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
