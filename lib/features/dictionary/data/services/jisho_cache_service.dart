import 'package:Keyra/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class JishoCacheService {
  static const String _boxName = 'jisho_cache';
  static const Duration _cacheValidDuration = Duration(hours: 24);
  
  late Box<Map> _box;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<Map>(_boxName);
      Logger.log('JishoCacheService: Cache initialized successfully');
    } catch (e) {
      Logger.error('JishoCacheService: Failed to initialize cache', error: e);
      // Don't rethrow - continue without cache if initialization fails
    }
  }

  Future<Map<String, dynamic>?> getCachedData(String word) async {
    try {
      if (!_box.isOpen) {
        Logger.log('JishoCacheService: Cache not initialized, fetching from network');
        return null;
      }

      final cacheEntry = _box.get(word);
      if (cacheEntry == null) return null;

      final timestamp = cacheEntry['timestamp'] as int;
      final isExpired = DateTime.now().millisecondsSinceEpoch - timestamp > _cacheValidDuration.inMilliseconds;

      if (isExpired) {
        await _box.delete(word);
        return null;
      }

      return Map<String, dynamic>.from(cacheEntry['data'] as Map);
    } catch (e) {
      Logger.error('JishoCacheService: Failed to get cached data', error: e);
      return null;
    }
  }

  Future<void> cacheData(String word, Map<String, dynamic> data) async {
    try {
      if (!_box.isOpen) {
        Logger.log('JishoCacheService: Cache not initialized, skipping cache');
        return;
      }

      await _box.put(word, {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      Logger.error('JishoCacheService: Failed to cache data', error: e);
    }
  }

  Future<void> clear() async {
    try {
      if (_box.isOpen) {
        await _box.clear();
      }
    } catch (e) {
      Logger.error('JishoCacheService: Failed to clear cache', error: e);
    }
  }
}
