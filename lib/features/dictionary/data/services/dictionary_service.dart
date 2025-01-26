import 'dart:async';
import 'package:Keyra/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/services/non_japanese_dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/services/japanese_dictionary_service.dart';
import 'package:Keyra/features/common/presentation/utils/connectivity_utils.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

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
  final NonJapaneseDictionaryService _nonJapaneseDictionary =
      NonJapaneseDictionaryService();
  final JapaneseDictionaryService _japaneseDictionary =
      JapaneseDictionaryService();
  String? _currentAudioUrl;
  bool _isPaused = false;

  final _definitionCache = <String, _CacheEntry<Map<String, dynamic>>>{};

  factory DictionaryService() {
    return _instance;
  }

  DictionaryService._internal();

  bool _isNonJapaneseDictionaryInitialized = false;
  bool _isJapaneseDictionaryInitialized = false;
  bool get isInitialized =>
      _isNonJapaneseDictionaryInitialized && _isJapaneseDictionaryInitialized;

  Future<void> initialize() async {
    if (_isNonJapaneseDictionaryInitialized &&
        _isJapaneseDictionaryInitialized) {
      Logger.log('DictionaryService already initialized');
      clearCache(); // Clear cache on initialization to ensure consistent data structure
      return;
    }

    try {
      Logger.log('Initializing DictionaryService...');

      // Initialize both dictionaries in parallel for better performance
      Logger.log('Initializing dictionaries...');
      await Future.wait([
        _nonJapaneseDictionary.initialize().then((_) {
          _isNonJapaneseDictionaryInitialized = true;
          Logger.log('Non-Japanese dictionary initialized successfully');
        }),
        _japaneseDictionary.initialize().then((_) {
          _isJapaneseDictionaryInitialized = true;
          Logger.log('Japanese dictionary initialized successfully');
        }),
      ]);

      Logger.log('DictionaryService initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize dictionaries', error: e);
      throw DictionaryException('Failed to initialize dictionary service: $e');
    }
  }

  Future<void> _ensureJapaneseDictionaryInitialized() async {
    if (!_isJapaneseDictionaryInitialized) {
      Logger.log('Re-initializing Japanese dictionary...');
      await _japaneseDictionary.initialize();

      if (!_japaneseDictionary.isInitialized) {
        throw DictionaryException('Japanese dictionary failed to initialize');
      }
      _isJapaneseDictionaryInitialized = true;
      Logger.log('Japanese dictionary re-initialized successfully');
    }
  }

  Future<void> close() async {
    try {
      // Only close audio player
      await _audioPlayer.stop();
      Logger.log('DictionaryService closed successfully');
    } catch (e) {
      Logger.error('Failed to close DictionaryService', error: e);
    }
  }

  void _checkInitialized() {
    if (!_isNonJapaneseDictionaryInitialized) {
      throw DictionaryException(
          'Dictionary service not initialized. Call initialize() first.');
    }
  }

  void _addToCache<T>(Map<String, _CacheEntry<T>> cache, String key, T value) {
    if (cache.length >= _maxCacheSize) {
      final oldestKey = cache.entries
          .reduce(
              (a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      cache.remove(oldestKey);
    }
    cache[key] = _CacheEntry(value);
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'fr':
        return 'fr';
      case 'es':
        return 'es';
      case 'de':
        return 'de';
      case 'it':
        return 'it';
      case 'ja':
        return 'ja';
      default:
        return 'en';
    }
  }

  Future<Map<String, dynamic>> getDefinition(
    String word,
    BookLanguage language,
    BuildContext context,
  ) async {
    try {
      if (!isInitialized) {
        throw DictionaryException('Dictionary service not initialized');
      }

      // For Japanese words, use Japanese dictionary
      if (language == BookLanguage.japanese) {
        return await _japaneseDictionary.getDefinition(word);
      }

      // For non-Japanese words, use non-Japanese dictionary
      final translations = UiTranslations.of(context);
      Logger.log('Current UI language: ${translations.currentLanguage}');
      final uiLanguage = translations.currentLanguage;
      return await _nonJapaneseDictionary.getDefinition(
        word,
        language: language.code,
        uiLanguage: uiLanguage,
      );
    } catch (e) {
      Logger.error('Error getting definition', error: e);
      throw DictionaryException('Failed to get definition: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _audioPlayer.stop();
  }

  Future<void> pauseSpeaking() async {
    _isPaused = true;
    await _audioPlayer.pause();
  }

  Future<void> speakWord(
      String word, String languageCode, BuildContext context) async {
    try {
      if (!await ConnectivityUtils.checkConnectivity(context)) {
        return;
      }

      final url = Uri.parse('https://translate.google.com/translate_tts'
              '?ie=UTF-8'
              '&q=${Uri.encodeComponent(word)}'
              '&tl=$languageCode'
              '&client=tw-ob')
          .toString();

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
      Logger.error('Failed to play audio', error: e);
    }
  }

  void clearCache() {
    _definitionCache.clear();
  }
}
