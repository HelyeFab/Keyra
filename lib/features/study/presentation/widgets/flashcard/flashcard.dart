import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import '../../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../../features/books/domain/models/book_language.dart';
import '../../../../../features/dictionary/data/services/local_kanjidict_service.dart';
import '../../../../../core/utils/logger.dart';

class Flashcard extends StatefulWidget {
  final String word;
  final String definition;
  final List<String>? examples;
  final FlipCardController controller;
  final String language;

  const Flashcard({
    super.key,
    required this.word,
    required this.definition,
    this.examples,
    required this.controller,
    required this.language,
  });

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  final LocalKanjiDictService _kanjiService = LocalKanjiDictService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeKanjiService();
  }

  @override
  void dispose() {
    _kanjiService.close();
    super.dispose();
  }

  Future<void> _initializeKanjiService() async {
    try {
      await _kanjiService.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      Logger.error('Failed to initialize KanjiDictService', error: e);
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeKanjiService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        final languageCode = uiLanguageState.languageCode;
        return FlipCard(
          controller: widget.controller,
          direction: FlipDirection.HORIZONTAL,
          front: _buildFrontCard(context, languageCode),
          back: _buildBackCard(context, languageCode),
        );
      },
    );
  }

  Widget _buildFrontCard(BuildContext context, String languageCode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.word,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              UiTranslationService.translate(context, 'language_${BookLanguage.fromCode(widget.language).name.toLowerCase()}'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              UiTranslationService.translate(context, 'tap_to_see_definition'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _getKanjiInfo(String kanji) async {
    if (!_isInitialized) {
      Logger.error('KanjiDictService not initialized');
      return null;
    }

    try {
      final entry = await _kanjiService.lookupKanji(kanji);
      if (entry != null) {
        return {
          'grade': entry.grade,
          'jlpt': entry.jlpt,
          'meanings': entry.meanings,
          'onReadings': entry.readings['on'] ?? [],
          'kunReadings': entry.readings['kun'] ?? [],
        };
      }
    } catch (e) {
      Logger.error('Error looking up kanji info', error: e);
    }
    return null;
  }

  Widget _buildKanjiInfo(BuildContext context, String kanji) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getKanjiInfo(kanji),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        final data = snapshot.data!;
        final meanings = data['meanings'] as List<String>;
        final onReadings = data['onReadings'] as List<String>;
        final kunReadings = data['kunReadings'] as List<String>;
        
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    kanji,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (data['grade'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Grade ${data['grade']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  if (data['jlpt'] != null)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'N${data['jlpt']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
              if (meanings.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  meanings.join(', '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (onReadings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'On: ${onReadings.join(', ')}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (kunReadings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Kun: ${kunReadings.join(', ')}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackCard(BuildContext context, String languageCode) {
    final definitionText = UiTranslationService.translate(context, 'definition');
    final examplesText = UiTranslationService.translate(context, 'examples');
    final tapToSeeWordText = UiTranslationService.translate(context, 'tap_to_see_word');
    
    // Extract kanji characters from the word if it's Japanese
    final kanjiCharacters = widget.language == 'ja' 
        ? widget.word.characters.where((char) {
            final code = char.codeUnitAt(0);
            return code >= 0x4E00 && code <= 0x9FFF;
          }).toList()
        : <String>[];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$definitionText:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.definition,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                    if (kanjiCharacters.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Kanji Information:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ...kanjiCharacters.map((kanji) => _buildKanjiInfo(context, kanji)),
                    ],
                    if (widget.examples != null && widget.examples!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '$examplesText:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.examples!.map((example) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '• $example',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                tapToSeeWordText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
