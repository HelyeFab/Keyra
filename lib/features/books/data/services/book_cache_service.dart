import 'package:Keyra/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/book.dart';

class BookCacheService {
  static const String _boxName = 'books';
  static const String _metaBoxName = 'books_meta';
  static const Duration _cacheValidDuration = Duration(hours: 24);
  static const int _currentVersion = 1;

  late Box<Book> _box;
  late Box<dynamic> _metaBox;

  Future<void> init() async {
    try {
      _box = await Hive.openBox<Book>(_boxName);
      _metaBox = await Hive.openBox(_metaBoxName);

      // Check cache version and clear if outdated
      final cachedVersion = _metaBox.get('version', defaultValue: 0);
      if (cachedVersion < _currentVersion) {
        await clear();
        await _metaBox.put('version', _currentVersion);
      }
    } catch (e) {
      Logger.error('BookCacheService: Failed to initialize cache', error: e);
      rethrow;
    }
  }

  Future<void> cacheBooks(List<Book> books) async {
    try {
      if (!_box.isOpen || !_metaBox.isOpen) {
        Logger.log('BookCacheService: Cache not initialized');
        return;
      }
      Logger.log('BookCacheService: Caching ${books.length} books');
      await _box.clear();
      await _box.putAll(
        Map.fromEntries(books.map((book) => MapEntry(book.id, book))),
      );
      await _metaBox.put('lastUpdated', DateTime.now().toIso8601String());
      Logger.log('BookCacheService: Cache updated successfully');
    } catch (e) {
      Logger.error('BookCacheService: Failed to cache books', error: e);
    }
  }

  List<Book> getCachedBooks() {
    try {
      if (!_box.isOpen || !_metaBox.isOpen) {
        Logger.log('BookCacheService: Cache not initialized');
        return [];
      }

      final lastUpdated = DateTime.parse(_metaBox.get('lastUpdated',
          defaultValue:
              DateTime.fromMillisecondsSinceEpoch(0).toIso8601String()));
      final isExpired =
          DateTime.now().difference(lastUpdated) > _cacheValidDuration;

      if (isExpired) {
        Logger.log('BookCacheService: Cache is expired');
        return [];
      }

      final books = _box.values.toList();
      Logger.log('BookCacheService: Returning ${books.length} cached books');
      return books;
    } catch (e) {
      Logger.error('BookCacheService: Failed to get cached books', error: e);
      return [];
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      if (!_box.isOpen) {
        Logger.log('BookCacheService: Cache not initialized');
        return;
      }
      Logger.log('BookCacheService: Updating book ${book.id}');
      await _box.put(book.id, book);
    } catch (e) {
      Logger.error('BookCacheService: Failed to update book', error: e);
    }
  }

  Future<void> clear() async {
    try {
      if (!_box.isOpen || !_metaBox.isOpen) {
        Logger.log('BookCacheService: Cache not initialized');
        return;
      }
      Logger.log('BookCacheService: Clearing cache');
      await _box.clear();
      await _metaBox.delete('lastUpdated');
    } catch (e) {
      Logger.error('BookCacheService: Failed to clear cache', error: e);
    }
  }

  bool get hasCache {
    try {
      if (!_box.isOpen || !_metaBox.isOpen) return false;
      if (_box.isEmpty) return false;

      final lastUpdated = DateTime.parse(_metaBox.get('lastUpdated',
          defaultValue:
              DateTime.fromMillisecondsSinceEpoch(0).toIso8601String()));
      return DateTime.now().difference(lastUpdated) <= _cacheValidDuration;
    } catch (e) {
      Logger.error('BookCacheService: Failed to check cache status', error: e);
      return false;
    }
  }

  DateTime? get lastUpdated {
    try {
      if (!_metaBox.isOpen) return null;
      final lastUpdatedStr = _metaBox.get('lastUpdated');
      return lastUpdatedStr != null ? DateTime.parse(lastUpdatedStr) : null;
    } catch (e) {
      Logger.error('BookCacheService: Failed to get last updated', error: e);
      return null;
    }
  }
}
