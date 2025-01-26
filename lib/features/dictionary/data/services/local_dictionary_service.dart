import 'dart:async';
import 'package:Keyra/core/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/config/api_keys.dart';

class LocalDictionaryService {
  static final _instance = LocalDictionaryService._internal();
  factory LocalDictionaryService() => _instance;
  LocalDictionaryService._internal();

  final String _dictionaryBaseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries';
  final String _translationBaseUrl =
      'https://translate.googleapis.com/translate_a/single';
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> recreateDatabase() async {
    // No database to recreate, but ensure we're initialized
    await initialize();
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception(
          'LocalDictionaryService not initialized. Call initialize() first.');
    }
  }

  Future<Map<String, dynamic>> getDefinition(String text,
      {String language = 'en', String? uiLanguage}) async {
    try {
      _checkInitialized();

      // Get examples in the book's language
      final examplesInBookLanguage =
          await _getExamplesInLanguage(text, language);

      if (language == 'en') {
        // For English text, get definition and translate it to UI language if needed
        final englishDef = await _getEnglishDefinition(text);
        if (uiLanguage != null && uiLanguage != 'en') {
          final uiLanguageDef = await _translateDefinition(
              englishDef, uiLanguage, examplesInBookLanguage);
          return {
            ...uiLanguageDef,
            'original_meanings':
                englishDef['meanings'], // Keep original English meanings
          };
        }
        return {...englishDef, 'examples': examplesInBookLanguage};
      } else {
        // For non-English text:
        // 1. Get definitions in book's language
        // 2. Get definitions in UI language
        final words = text.split(RegExp(r'\s+'));
        if (words.isEmpty) return {'word': text};

        final word =
            words[0].replaceAll(RegExp(r'[^\p{L}\s]+', unicode: true), '');
        if (word.isEmpty) return {'word': text};

        // Get definitions with translations to both book language and UI language
        final definitions = await _getTranslationWithExamples(
            word, language, uiLanguage ?? language, examplesInBookLanguage);

        Logger.log('Got definitions with translations');
        return {
          'word': word,
          ...definitions,
          'examples': examplesInBookLanguage,
        };
      }
    } catch (e) {
      Logger.error('Failed to get definition', error: e);
      return {'word': text};
    }
  }

  Future<Map<String, dynamic>> _getEnglishDefinition(String word) async {
    final response = await http.get(Uri.parse('$_dictionaryBaseUrl/en/$word'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final entry = data[0];
        final meanings = entry['meanings'] as List<dynamic>;

        // Extract definitions and examples
        final List<dynamic> definitions = [];
        final List<String> examples = [];

        for (var meaning in meanings) {
          final defs = meaning['definitions'] as List<dynamic>;
          for (var def in defs) {
            // Add definition
            definitions.add(def['definition'].toString());

            // Add example if available
            if (def['example'] != null) {
              examples.add(def['example'].toString());
            }
          }
        }

        return {
          'word': entry['word'] ?? word,
          'reading': entry['phonetic'] ?? '',
          'meanings': definitions,
          'partsOfSpeech':
              meanings.map((m) => m['partOfSpeech'].toString()).toList(),
          'examples': examples,
        };
      }
    }
    return {'word': word};
  }

  Future<List<String>> _getExamplesInLanguage(
      String text, String language) async {
    try {
      if (language == 'en') {
        return await _getExampleSentences(text);
      }

      // First get English examples
      final englishExamples = await _getExampleSentences(text);

      // Then translate them to the target language
      final translatedExamples = await Future.wait(englishExamples
          .map((example) => translateText(example, 'en', language)));

      return translatedExamples.whereType<String>().toList();
    } catch (e) {
      Logger.error('Failed to get examples', error: e);
      return [];
    }
  }

  Future<String?> translateText(
      String text, String fromLang, String toLang) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_translationBaseUrl?client=gtx&sl=$fromLang&tl=$toLang&dt=t&q=${Uri.encodeComponent(text)}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data[0] != null && data[0][0] != null) {
          return data[0][0][0] as String;
        }
      }
    } catch (e) {
      Logger.error('Translation failed', error: e);
    }
    return null;
  }

  Future<Map<String, dynamic>> _translateDefinition(
      Map<String, dynamic> englishDef,
      String targetLang,
      List<String> examples) async {
    final meanings = englishDef['meanings'] as List;
    final translatedMeanings = await Future.wait(meanings
        .take(6)
        .map((m) => translateText(m.toString(), 'en', targetLang)));

    return {
      'word': englishDef['word'],
      'reading': englishDef['reading'],
      'meanings': translatedMeanings.whereType<String>().toList(),
      'original_meanings': meanings, // Store original English meanings
      'partsOfSpeech': englishDef['partsOfSpeech'],
      'examples': examples,
    };
  }

  Future<Map<String, dynamic>> _getTranslationWithExamples(String text,
      String bookLang, String uiLang, List<String> examples) async {
    try {
      Logger.log(
          'Getting translation with examples for: $text (bookLang: $bookLang, uiLang: $uiLang)');

      // For non-English words, translate to English first to get definitions
      final englishTranslation = await translateText(text, bookLang, 'en');
      if (englishTranslation == null) {
        Logger.error('Failed to translate to English');
        return {'word': text};
      }

      Logger.log('English translation: $englishTranslation');

      // Get English definitions
      final englishDef = await _getEnglishDefinition(englishTranslation);
      List<String> meanings = [];
      List<String> partsOfSpeech = [];

      if (englishDef.containsKey('meanings')) {
        meanings = (englishDef['meanings'] as List)
            .take(6)
            .map((m) => m.toString())
            .toList();
        partsOfSpeech = englishDef['partsOfSpeech'] as List<String>? ?? [];
      }

      if (meanings.isEmpty) {
        meanings = [englishTranslation];
      }

      // Now translate meanings back to book language for original meanings
      Logger.log('Translating meanings to book language: $bookLang');
      final bookLanguageMeanings = await Future.wait(
          meanings.map((m) => translateText(m, 'en', bookLang)));
      final originalMeanings =
          bookLanguageMeanings.whereType<String>().toList();

      // Handle UI language translations
      List<String> uiMeanings;
      if (uiLang == 'en') {
        // If UI language is English, use the English meanings directly
        uiMeanings = meanings;
      } else if (uiLang == bookLang) {
        // If UI language is same as book language, use the book language meanings
        uiMeanings = originalMeanings;
      } else {
        // Otherwise translate to UI language
        Logger.log('Translating meanings to UI language: $uiLang');
        final translatedMeanings = await Future.wait(
            meanings.map((m) => translateText(m, 'en', uiLang)));
        uiMeanings = translatedMeanings.whereType<String>().toList();
      }

      Logger.log('Final meanings: $uiMeanings');
      Logger.log('Original meanings: $originalMeanings');

      return {
        'word': text,
        'reading': '',
        'meanings': uiMeanings,
        'original_meanings': originalMeanings,
        'partsOfSpeech': partsOfSpeech,
        'examples': examples,
      };
    } catch (e) {
      Logger.error('Translation failed', error: e);
      return {'word': text};
    }
  }

  Future<List<String>> _getExampleSentences(String word) async {
    try {
      // Get example sentences from the Free Dictionary API
      final response =
          await http.get(Uri.parse('$_dictionaryBaseUrl/en/$word'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final entry = data[0];
          final meanings = entry['meanings'] as List<dynamic>;

          // Extract example sentences from definitions
          final examples = meanings
              .expand((m) => (m['definitions'] as List<dynamic>))
              .where((d) => d['example'] != null)
              .map((d) => d['example'].toString())
              .take(3) // Get up to 3 examples
              .toList();

          return examples;
        }
      }
    } catch (e) {
      Logger.error('Failed to get example sentences', error: e);
    }
    return [];
  }

  Future<List<Map<String, String>>> getExampleSentences(String word) async {
    // Currently not implemented for non-Japanese languages
    return [];
  }
}
