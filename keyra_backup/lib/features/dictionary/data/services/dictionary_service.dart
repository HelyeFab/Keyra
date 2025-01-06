import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/services/local_dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/services/japanese_dictionary_service.dart';

class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry(this.value) : timestamp = DateTime.now();

  bool get isExpired => 
    DateTime.now().difference(timestamp) > DictionaryService._cacheTimeout;
}

class WordReading {
  final String word;
  final String? reading;

  WordReading(this.word, this.reading);

  Map<String, dynamic> toJson() => {
    'word': word,
    'reading': reading,
  };

  factory WordReading.fromJson(Map<String, dynamic> json) => WordReading(
    json['word'] as String,
    json['reading'] as String?,
  );
}

class DictionaryException implements Exception {
  final String message;
  DictionaryException(this.message);
  @override
  String toString() => message;
}

class DictionaryService {
  static const Duration _cacheTimeout = Duration(minutes: 30);
  static const int _maxCacheSize = 1000;

  static final DictionaryService _instance = DictionaryService._internal();
  final _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final LocalDictionaryService _localDictionary = LocalDictionaryService();
  final JapaneseDictionaryService _japaneseDictionary = JapaneseDictionaryService();
  String? _currentAudioUrl;
  bool _isPaused = false;

  final _definitionCache = <String, _CacheEntry<Map<String, dynamic>>>{};

  factory DictionaryService() {
    return _instance;
  }

  DictionaryService._internal();

  bool get isDictionaryInitialized => _japaneseDictionary.isInitialized;

  Future<void> initialize() async {
    try {
      await _localDictionary.recreateDatabase();
      await _japaneseDictionary.initialize();
    } catch (e) {
      debugPrint('Error initializing dictionaries: $e');
    }
  }

  void _addToCache<T>(Map<String, _CacheEntry<T>> cache, String key, T value) {
    if (cache.length >= _maxCacheSize) {
      final oldestKey = cache.entries
          .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      cache.remove(oldestKey);
    }
    cache[key] = _CacheEntry(value);
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'fr': return 'fr';
      case 'es': return 'es';
      case 'de': return 'de';
      case 'it': return 'it';
      case 'ja': return 'ja';
      default: return 'en';
    }
  }

  Future<Map<String, String>?> _translateWithSourceLanguage(String text, String sourceLanguage, String targetLanguage) async {
    try {
      if (text.isEmpty || sourceLanguage.isEmpty || targetLanguage.isEmpty) {
        debugPrint('Invalid translation parameters: text=$text, source=$sourceLanguage, target=$targetLanguage');
        throw DictionaryException('Invalid translation parameters');
      }

      debugPrint('Translating: "$text" from $sourceLanguage to $targetLanguage');
      
      final response = await _dio.post(
        'https://translation.googleapis.com/language/translate/v2',
        queryParameters: {
          'key': ApiKeys.googleApiKey,
        },
        data: {
          'q': text,
          'source': sourceLanguage,
          'target': targetLanguage,
          'format': 'text',
        },
      );

      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['data'] != null &&
          response.data['data']['translations'] != null &&
          response.data['data']['translations'].isNotEmpty) {
        
        final translation = response.data['data']['translations'][0];
        final translatedText = translation['translatedText'] as String;
        final detectedSourceLanguage = (translation['detectedSourceLanguage'] ?? sourceLanguage) as String;
        
        return {
          'translatedText': translatedText,
          'detectedSourceLanguage': detectedSourceLanguage,
        };
      }

      return null;
    } catch (e) {
      debugPrint('Error during translation: $e');
      throw DictionaryException('Failed to translate text: $e');
    }
  }

  Future<Map<String, dynamic>> getDefinition(String word, BookLanguage language) async {
    try {
      // Check cache first
      final cacheKey = '${language.code}:$word';
      final cached = _definitionCache[cacheKey];
      if (cached != null && !cached.isExpired) {
        return cached.value;
      }

      Map<String, dynamic>? definition;
      
      if (language.code == 'ja') {
        definition = await _japaneseDictionary.getDefinition(word);
      } else {
        definition = await _localDictionary.getDefinition(word, language: language.code);
      }
      
      final result = definition ?? {'word': word};
      _addToCache(_definitionCache, cacheKey, result);
      return result;
    } catch (e) {
      debugPrint('Error getting definition: $e');
      return {'word': word};
    }
  }

  Future<void> stopSpeaking() async {
    await _audioPlayer.stop();
  }

  Future<void> pauseSpeaking() async {
    _isPaused = true;
    await _audioPlayer.pause();
  }

  Future<void> speakWord(String word, String language) async {
    try {
      final url = Uri.parse(
        'https://translate.google.com/translate_tts'
        '?ie=UTF-8'
        '&q=${Uri.encodeComponent(word)}'
        '&tl=$language'
        '&client=tw-ob'
      ).toString();

      if (_isPaused && url == _currentAudioUrl) {
        _isPaused = false;
        await _audioPlayer.resume();
      } else {
        _currentAudioUrl = url;
        _isPaused = false;
        await _audioPlayer.play(UrlSource(url));
      }
      await _audioPlayer.onPlayerComplete.first;
      _isPaused = false;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void clearCache() {
    _definitionCache.clear();
  }
}
