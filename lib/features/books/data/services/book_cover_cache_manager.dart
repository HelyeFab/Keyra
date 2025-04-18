import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// A cache manager specifically designed for handling book cover images.
class BookCoverCacheManager extends CacheManager {
  static const String key = 'bookCoverCache';
  static const Duration stalePeriod = Duration(days: 7);
  static const int maxNrOfCacheObjects = 200;

  static final BookCoverCacheManager _instance = BookCoverCacheManager._();

  /// Get the singleton instance
  static BookCoverCacheManager get instance => _instance;

  BookCoverCacheManager._() : super(Config(
    key,
    stalePeriod: stalePeriod,
    maxNrOfCacheObjects: maxNrOfCacheObjects,
    repo: JsonCacheInfoRepository(databaseName: key),
    fileSystem: IOFileSystem(key),
    fileService: HttpFileService(),
  ));

  /// Pre-caches a list of book cover images.
  Future<void> preCacheBookCovers(List<String> urls) async {
    for (final url in urls) {
      try {
        final file = await getSingleFile(url);
        if (file.existsSync()) {
          // File is now cached and ready for CachedNetworkImage to use
          Logger.log('Successfully cached cover: $url');
        }
      } catch (e) {
        Logger.error('Failed to cache cover', error: e, throwError: false);
        // Continue with next URL even if one fails
        continue;
      }
    }
  }
}
