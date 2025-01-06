import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/core/config/app_strings.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';

class JapaneseWordDefinitionModal extends StatefulWidget {
  final String word;
  final BookLanguage language;

  const JapaneseWordDefinitionModal({
    super.key,
    required this.word,
    required this.language,
  });

  static Future<void> show(
    BuildContext context,
    String word,
    BookLanguage language,
  ) {
    final height = MediaQuery.of(context).size.height * 0.6;
    
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: JapaneseWordDefinitionModal(
            word: word,
            language: language,
          ),
        ),
      ),
    );
  }

  @override
  State<JapaneseWordDefinitionModal> createState() => _JapaneseWordDefinitionModalState();
}

class _JapaneseWordDefinitionModalState extends State<JapaneseWordDefinitionModal> {
  final DictionaryService _dictionaryService = DictionaryService();
  final SavedWordsRepository _savedWordsRepository = SavedWordsRepository();
  Map<String, dynamic>? _definition;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSaved = false;
  String? _error;
  String? _savedWordId;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkIfWordIsSaved();
  }

  Widget _formatMnemonicText(String text, ThemeData theme, {Color? textColor}) {
    final pattern = RegExp(r'<(radical|kanji|reading)>(.*?)</\1>');
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in pattern.allMatches(text)) {
      // Add text before the tag
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor ?? theme.colorScheme.onSurface,
          ),
        ));
      }

      // Add the tagged text with special formatting
      final tag = match.group(1)!;
      final content = match.group(2)!;
      
      Color tagColor;
      switch (tag) {
        case 'radical':
          tagColor = const Color(0xFF00AAFF); // Blue for radicals
          break;
        case 'kanji':
          tagColor = const Color(0xFFFF00AA); // Pink for kanji
          break;
        case 'reading':
          tagColor = const Color(0xFF00AA55); // Green for readings
          break;
        default:
          tagColor = theme.colorScheme.primary;
      }

      spans.add(
        TextSpan(
          text: content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: tagColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastEnd = match.end;
    }

    // Add any remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
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
        final meanings = _definition!['meanings'] as List<dynamic>?;
        
        // For Japanese, use primary meaning if available
        if (meanings != null && meanings.isNotEmpty) {
          Map<String, dynamic>? primaryMeaning;
          
          // First try to find a meaning marked as primary
          for (final m in meanings) {
            if (m is Map<String, dynamic> && m['primary'] == true) {
              primaryMeaning = m;
              break;
            }
          }
          
          // If no primary meaning found, use the first one
          if (primaryMeaning == null && meanings.isNotEmpty) {
            final firstMeaning = meanings.first;
            if (firstMeaning is Map<String, dynamic>) {
              primaryMeaning = firstMeaning;
            }
          }
          
          definition = primaryMeaning != null 
              ? '${primaryMeaning['meaning']} (${_definition!['reading'] ?? ''})'
              : 'No definition available';
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
            ? 'This word is already in your saved words'
            : 'Failed to update word';

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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_definition?['reading'] != null)
                    RubyText(
                      [RubyTextData(
                        widget.word,
                        ruby: _definition!['reading'],
                      )],
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
                      DictionaryService().speakWord(widget.word, widget.language.code);
                    },
                  ),
                ],
              ),
              if (_definition?['partsOfSpeech'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      (_definition!['partsOfSpeech'] as List).join(', '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              if (_definition?['source'] == 'wanikani' && 
                  _definition?['wanikani']?['level'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Level ${_definition!['wanikani']['level']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
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
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meaning['meaning']?.toString() ?? '',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              if (meaning['primary'] == true)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Primary',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
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

  List<Widget> _buildWanikaniSections(ThemeData theme, Map<String, dynamic> wanikaniData) {
    final widgets = <Widget>[];

    // Readings section
    if (wanikaniData['readings'] != null) {
      widgets.add(
        Container(
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
                'Readings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ...(wanikaniData['readings'] as List)
                  .map((reading) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Text(
                              '${reading['type'] == 'kunyomi' ? 'Kun' : 'On'}: ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              reading['reading']?.toString() ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (reading['primary'] == true)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Primary',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ))
                  ,
            ],
          ),
        ),
      );
    }

    // Meaning Mnemonic section
    if (wanikaniData['meaning_mnemonic'] != null) {
      widgets.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meaning Mnemonic',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              _formatMnemonicText(
                wanikaniData['meaning_mnemonic']?.toString() ?? '',
                theme,
                textColor: theme.colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      );
    }

    // Reading Mnemonic section
    if (wanikaniData['reading_mnemonic'] != null) {
      widgets.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading Mnemonic',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              _formatMnemonicText(
                wanikaniData['reading_mnemonic']?.toString() ?? '',
                theme,
                textColor: theme.colorScheme.onTertiaryContainer,
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildContent() {
    final theme = Theme.of(context);
    Map<String, dynamic>? wanikaniData;
    
    if (_definition != null && _definition!['source'] == 'wanikani') {
      wanikaniData = _definition!['wanikani'] as Map<String, dynamic>;
    }
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          _buildMeaningsSection(theme),
          if (wanikaniData != null)
            ..._buildWanikaniSections(theme, wanikaniData),
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
