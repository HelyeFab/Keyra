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
    _box = await Hive.openBox<Book>(_boxName);
    _metaBox = await Hive.openBox(_metaBoxName);
    
    // Check cache version and clear if outdated
    final cachedVersion = _metaBox.get('version', defaultValue: 0);
    if (cachedVersion < _currentVersion) {
      await clear();
      await _metaBox.put('version', _currentVersion);
    }
  }

  Future<void> cacheBooks(List<Book> books) async {
    print('BookCacheService: Caching ${books.length} books');
    await _box.clear();
    await _box.putAll(
      Map.fromEntries(books.map((book) => MapEntry(book.id, book))),
    );
    await _metaBox.put('lastUpdated', DateTime.now().toIso8601String());
    print('BookCacheService: Cache updated successfully');
  }

  List<Book> getCachedBooks() {
    final lastUpdated = DateTime.parse(
      _metaBox.get('lastUpdated', defaultValue: DateTime.fromMillisecondsSinceEpoch(0).toIso8601String())
    );
    final isExpired = DateTime.now().difference(lastUpdated) > _cacheValidDuration;
    
    if (isExpired) {
      print('BookCacheService: Cache is expired');
      return [];
    }
    
    final books = _box.values.toList();
    print('BookCacheService: Returning ${books.length} cached books');
    return books;
  }

  Future<void> updateBook(Book book) async {
    print('BookCacheService: Updating book ${book.id}');
    await _box.put(book.id, book);
  }

  Future<void> clear() async {
    print('BookCacheService: Clearing cache');
    await _box.clear();
    await _metaBox.delete('lastUpdated');
  }

  bool get hasCache {
    if (_box.isEmpty) return false;
    
    final lastUpdated = DateTime.parse(
      _metaBox.get('lastUpdated', defaultValue: DateTime.fromMillisecondsSinceEpoch(0).toIso8601String())
    );
    return DateTime.now().difference(lastUpdated) <= _cacheValidDuration;
  }

  DateTime? get lastUpdated {
    final lastUpdatedStr = _metaBox.get('lastUpdated');
    return lastUpdatedStr != null ? DateTime.parse(lastUpdatedStr) : null;
  }
}
