import 'package:Keyra/core/utils/logger.dart';
import 'package:characters/characters.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/services/local_jmdict_service.dart';
import 'package:Keyra/features/dictionary/data/services/local_kanjidict_service.dart';

class JapaneseDictionaryService {
  static final LocalJMDictService _jmDictService = LocalJMDictService();
  static final LocalKanjiDictService _kanjiDictService = LocalKanjiDictService();
  static final JapaneseDictionaryService _instance = JapaneseDictionaryService._internal();

  factory JapaneseDictionaryService() {
    return _instance;
  }

  JapaneseDictionaryService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) {
      Logger.log('JapaneseDictionaryService already initialized');
      return;
    }

    try {
      Logger.log('JapaneseDictionaryService - Initializing dictionaries...');
      // Initialize JMDict first as it's required
      await _jmDictService.initialize();
      Logger.log('JMDict service initialized successfully');

      // Try to initialize KanjiDict but don't fail if it errors
      try {
        await _kanjiDictService.initialize();
        Logger.log('KanjiDict service initialized successfully');
      } catch (e) {
        Logger.error('Failed to initialize KanjiDict service', error: e);
        // Continue without kanji support
      }

      _isInitialized = true;
      Logger.log('JapaneseDictionaryService - All dictionaries initialized successfully');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to initialize JapaneseDictionaryService',
        error: e,
        stackTrace: stackTrace,
      );
      throw DictionaryException('Failed to initialize Japanese dictionary: $e');
    }
  }

  Future<void> close() async {
    // Do nothing - we want to keep the dictionaries initialized
    Logger.log('JapaneseDictionaryService - Keeping dictionaries initialized');
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw DictionaryException(
          'Japanese dictionary service not initialized. Call initialize() first.');
    }
  }

  Future<Map<String, dynamic>> getDefinition(String word) async {
    try {
      _checkInitialized();
      Logger.log('Getting dictionary data for: $word');

      final result = <String, dynamic>{};
      var foundDefinition = false;

      // Handle particles first
      final particles = [
        'の',
        'は',
        'を',
        'が',
        'で',
        'に',
        'と',
        'へ',
        'より',
        'から',
        'まで'
      ];
      String? particle;
      String baseWord = word;

      // Find the longest matching particle
      for (final p in particles) {
        if (word.endsWith(p) &&
            (particle == null || p.length > particle.length)) {
          particle = p;
          baseWord = word.substring(0, word.length - p.length);
        }
      }

      // Try looking up the base word first if a particle was found
      var jmdictEntries =
          await _jmDictService.lookupWord(particle != null ? baseWord : word);

      // If no entries found with base word, try the full word
      if (jmdictEntries.isEmpty && particle != null) {
        jmdictEntries = await _jmDictService.lookupWord(word);
      } else if (particle != null) {
        // If we found entries for the base word, add the particle information
        result['particle'] = {
          'value': particle,
          'position': 'suffix',
        };
        result['base_word'] = baseWord;
      }

      // Add JMDict results if found
      if (jmdictEntries.isNotEmpty) {
        final jmdictEntry = jmdictEntries.first;
        result['word'] = word;
        result['reading'] = jmdictEntry.reading;
        result['jmdict_meanings'] = jmdictEntry.meanings
            .map((m) => {
                  'meaning': m,
                  'primary': false,
                })
            .toList();
        result['parts_of_speech'] = jmdictEntry.partsOfSpeech;
        foundDefinition = true;

        // Add examples if available
        if (jmdictEntry.examples != null && jmdictEntry.examples!.isNotEmpty) {
          result['examples'] = jmdictEntry.examples!
              .map((e) => {
                    'japanese': e.japanese,
                    'english': e.english,
                  })
              .toList();
        }
      }

      // Get KanjiDict entries for each kanji in the word
      final kanjiList = <Map<String, dynamic>>[];
      final wordToProcess = result['base_word'] ?? word;

      // Process each character for kanji
      final chars = Characters(wordToProcess).toList();
      for (final char in chars) {
        if (_isKanji(char)) {
          try {
            final kanjiEntry = await _kanjiDictService.lookupKanji(char);
            if (kanjiEntry != null) {
              kanjiList.add({
                'literal': char,
                'meanings': kanjiEntry.meanings,
                'readings': {
                  'on': kanjiEntry.readings['on'] ?? [],
                  'kun': kanjiEntry.readings['kun'] ?? []
                },
                'grade': kanjiEntry.grade,
                'jlpt': kanjiEntry.jlpt,
                'strokeCount': kanjiEntry.strokeCount,
              });
              foundDefinition = true;
            }
          } catch (e) {
            Logger.log('Failed to lookup kanji $char, continuing...');
          }
        }
      }
      if (kanjiList.isNotEmpty) {
        result['kanji_info'] = kanjiList;
      }

      // If no entries found at all, throw an error
      if (!foundDefinition) {
        throw DictionaryException('Found 0 entries');
      }

      // Log the final result
      Logger.log('\n=== Japanese Dictionary Results ===');
      Logger.log('Word: ${result['word']}');
      if (result.containsKey('base_word')) {
        Logger.log('Base Word: ${result['base_word']}');
        Logger.log('Particle: ${result['particle']['value']}');
      }
      if (result.containsKey('reading')) {
        Logger.log('Reading: ${result['reading']}');
      }
      if (result.containsKey('jmdict_meanings')) {
        Logger.log('JMDict Meanings:');
        for (final meaning in result['jmdict_meanings'] as List) {
          Logger.log('• ${meaning['meaning']}');
        }
      }
      if (result.containsKey('kanji_info')) {
        Logger.log('\nKanji Information:');
        for (final kanji in result['kanji_info'] as List) {
          Logger.log('Kanji: ${kanji['literal']}');
          Logger.log('Meanings: ${kanji['meanings'].join(', ')}');
          final readings = kanji['readings'] as Map<String, List>;
          if (readings['on']?.isNotEmpty ?? false) {
            Logger.log('On Readings: ${readings['on']?.join(', ')}');
          }
          if (readings['kun']?.isNotEmpty ?? false) {
            Logger.log('Kun Readings: ${readings['kun']?.join(', ')}');
          }
          Logger.log('---');
        }
      }
      if (result.containsKey('examples')) {
        Logger.log('\nExample Sentences:');
        for (final example in result['examples'] as List) {
          Logger.log('Japanese: ${example['japanese']}');
          Logger.log('English: ${example['english']}');
          Logger.log('---');
        }
      }
      Logger.log('=== End of Results ===\n');

      return result;
    } catch (e) {
      Logger.error('Failed to get definition', error: e);
      throw DictionaryException('Failed to get definition: ${e.toString()}');
    }
  }

  bool _isKanji(String char) {
    final codeUnit = char.codeUnitAt(0);
    return (codeUnit >= 0x4E00 &&
            codeUnit <= 0x9FFF) || // CJK Unified Ideographs
        (codeUnit >= 0x3400 &&
            codeUnit <= 0x4DBF); // CJK Unified Ideographs Extension A
  }
}
