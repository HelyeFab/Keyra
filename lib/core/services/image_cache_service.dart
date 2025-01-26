import 'package:Keyra/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  static const String _boxName = 'image_cache';
  static const Duration _cacheValidDuration = Duration(hours: 24);
  
  final _cacheManager = DefaultCacheManager();
  late Box<dynamic> _box;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      Logger.log('ImageCacheService: Cache initialized successfully');
    } catch (e) {
      Logger.error('ImageCacheService: Failed to initialize cache', error: e);
      // Don't rethrow - continue without cache if initialization fails
    }
  }

  Future<String?> getCachedImageUrl(String originalUrl) async {
    try {
      if (!_box.isOpen) {
        Logger.log('ImageCacheService: Cache not initialized');
        return originalUrl;
      }

      try {
        // Check if we have a cached file
        final fileInfo = await _cacheManager.getFileFromCache(originalUrl);
        if (fileInfo != null) {
          Logger.log('ImageCacheService: Using cached file');
          return fileInfo.file.path;
        }

        // If not cached, download and cache
        Logger.log('ImageCacheService: Downloading and caching file');
        final file = await _cacheManager.downloadFile(originalUrl);
        return file.file.path;
      } catch (e) {
        Logger.error('ImageCacheService: Cache operation failed', error: e);
        Logger.log('ImageCacheService: Falling back to original URL');
        return originalUrl;
      }
    } catch (e) {
      Logger.error('ImageCacheService: Failed to get cached image', error: e);
      return originalUrl;
    }
  }

  Future<void> clear() async {
    try {
      await _cacheManager.emptyCache();
      if (_box.isOpen) {
        await _box.clear();
      }
    } catch (e) {
      Logger.error('ImageCacheService: Failed to clear cache', error: e);
    }
  }
}
