import 'package:flutter/material.dart';
import '../translations/ui_translations.dart';

class UiTranslationService {
  static final Map<String, String> _cache = {};
  static final Map<String, int> _cacheHits = {};
  static bool _isLoading = false;
  
  static String translate(BuildContext context, String key, [List<String>? args, bool listen = true]) {
    // Check cache first
    if (_cache.containsKey(key)) {
      _cacheHits[key] = (_cacheHits[key] ?? 0) + 1;
      var text = _cache[key]!;
      return _replaceArgs(text, args);
    }
    
    final uiTranslations = UiTranslations.of(context);
    var text = uiTranslations.translate(key);
    
    // Cache the translation
    _cache[key] = text;
    
    return _replaceArgs(text, args);
  }

  static String _replaceArgs(String text, List<String>? args) {
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i]);
      }
    }
    return text;
  }

  static Future<void> loadTranslations(BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    
    try {
      // Simulate async loading
      await Future.delayed(const Duration(milliseconds: 100));
      final uiTranslations = UiTranslations.of(context);
      _cache.clear();
      
      // Pre-load common translations
      const commonKeys = ['next', 'back', 'cancel', 'confirm'];
      for (final key in commonKeys) {
        _cache[key] = uiTranslations.translate(key);
      }
    } finally {
      _isLoading = false;
    }
  }

  static void clearCache() {
    _cache.clear();
    _cacheHits.clear();
  }

  static int getCacheHitCount(String key) {
    return _cacheHits[key] ?? 0;
  }

  // For testing purposes
  @visibleForTesting
  static bool get isLoading => _isLoading;
}
