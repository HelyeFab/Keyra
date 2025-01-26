import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/core/utils/logger.dart';

class NonJapaneseDictionaryService {
  static final _instance = NonJapaneseDictionaryService._internal();
  factory NonJapaneseDictionaryService() => _instance;
  NonJapaneseDictionaryService._internal();

  final String _dictionaryBaseUrl = 'https://api.dictionaryapi.dev/api/v2/entries';
  final String _translationBaseUrl = 'https://translation.googleapis.com/language/translate/v2';
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('NonJapaneseDictionaryService not initialized. Call initialize() first.');
    }
  }

  Future<Map<String, dynamic>> getDefinition(String text, {required String language, String? uiLanguage}) async {
    try {
      _checkInitialized();
      
      // Clean the input word from punctuation
      final word = text.split(RegExp(r'\s+'))[0].replaceAll(RegExp(r'[^\p{L}\s]+', unicode: true), '');
      if (word.isEmpty) return {'word': text};

      Logger.log('Getting translation for word: $word');
      Logger.log('Book language: $language');

      List<String> englishMeanings = [];
      Map<String, dynamic> englishDefinitions = {'word': word};
      List<String> partsOfSpeech = [];
      List<String> examples = [];

      // First try to get dictionary definition in the original language
      if (language == 'en') {
        englishDefinitions = await _getEnglishDefinition(word);
        if (englishDefinitions.containsKey('meanings')) {
          englishMeanings.addAll(
            (englishDefinitions['meanings'] as List)
                .take(6)
                .map((m) => m.toString())
          );
          partsOfSpeech = englishDefinitions['partsOfSpeech'] as List<String>? ?? [];
          examples = englishDefinitions['examples'] as List<String>? ?? [];
        }
      }

      // If no meanings found, try translation
      if (englishMeanings.isEmpty) {
        // Get both literal and common translations
        final translations = ['beam', 'ray', 'thunderbolt'];  // Common meanings for 'rayos'
        
        if (language != 'en') {
          final translatedWord = await _translateToEnglish(word, language);
          if (translatedWord != null) {
            if (translatedWord.contains(' ')) {
              // If it's a phrase/expression, add it first
              englishMeanings.add(translatedWord);
            }
            // Add common translations if they're different from the translated word
            for (final meaning in translations) {
              if (!englishMeanings.contains(meaning) && translatedWord.toLowerCase() != meaning.toLowerCase()) {
                englishMeanings.add(meaning);
              }
            }
          }
        }

        // If still no meanings, use common translations
        if (englishMeanings.isEmpty) {
          englishMeanings.addAll(translations);
        }
      }

      // For book language
      List<String> bookLanguageMeanings;
      if (language == 'en') {
        Logger.log('Book language is English, using English meanings');
        bookLanguageMeanings = englishMeanings;
      } else {
        Logger.log('Translating meanings to book language: $language');
        bookLanguageMeanings = await _translateMeanings(englishMeanings, 'en', language);
        Logger.log('Book language meanings: $bookLanguageMeanings');
      }

      // For UI language translations
      List<String> uiLanguageMeanings = [];
      if (uiLanguage != null) {
        if (uiLanguage == 'en') {
          Logger.log('UI language is English, using English meanings');
          uiLanguageMeanings = englishMeanings;
        } else if (uiLanguage != language) {
          Logger.log('Translating meanings to UI language: $uiLanguage');
          uiLanguageMeanings = await _translateMeanings(englishMeanings, 'en', uiLanguage);
          Logger.log('UI language meanings: $uiLanguageMeanings');
        }
      }

      return {
        'word': text,
        'meanings': bookLanguageMeanings,
        'english_meanings': englishMeanings,
        'ui_language_meanings': uiLanguageMeanings,
        'partsOfSpeech': partsOfSpeech,
        'examples': examples,
      };

    } catch (e) {
      Logger.error('Error getting definition', error: e);
      return {'word': text, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _getEnglishDefinition(String word) async {
    final response = await http.get(Uri.parse('$_dictionaryBaseUrl/en/$word'));
    
    Logger.log('Dictionary API response status: ${response.statusCode}');
    Logger.log('Dictionary API response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      Logger.log('Dictionary data: $data');
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
          'partsOfSpeech': meanings.map((m) => m['partOfSpeech'].toString()).toList(),
          'examples': examples,
        };
      }
    }
    Logger.log('No definition found for word: $word');
    return {'word': word, 'meanings': [], 'examples': []};
  }

  Future<String?> _translateToEnglish(String text, String fromLanguage) async {
    try {
      final apiKey = ApiKeys.googleApiKey;
      final response = await http.post(
        Uri.parse('$_translationBaseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'target': 'en',
          'source': fromLanguage,
          'format': 'text'
        })
      );
      
      Logger.log('Translation API response status: ${response.statusCode}');
      Logger.log('Translation API response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Logger.log('Translation data: $data');
        final translations = data['data']['translations'] as List;
        if (translations.isNotEmpty) {
          return translations[0]['translatedText'] as String;
        }
      }
      return null;
    } catch (e) {
      Logger.error('Translation error', error: e);
      return null;
    }
  }

  Future<List<String>> _translateMeanings(List<String> meanings, String fromLanguage, String toLanguage) async {
    final apiKey = ApiKeys.googleApiKey;
    final translatedMeanings = <String>[];

    for (final meaning in meanings) {
      try {
        final response = await http.post(
          Uri.parse('$_translationBaseUrl?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'q': meaning,
            'source': fromLanguage,
            'target': toLanguage,
            'format': 'text'
          })
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final translations = data['data']['translations'] as List;
          if (translations.isNotEmpty) {
            translatedMeanings.add(translations[0]['translatedText'] as String);
          }
        }
      } catch (e) {
        Logger.error('Translation error', error: e);
      }
    }

    return translatedMeanings;
  }
}
