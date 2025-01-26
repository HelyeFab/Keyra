import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/dictionary/domain/models/kanji_dict_entry.dart';

class LocalKanjiDictService {
  static const String _serviceName = 'LocalKanjiDictService';
  static const String _dbName = 'kanjidict.db';
  static const String _tableName = 'kanji';
  static final LocalKanjiDictService _instance =
      LocalKanjiDictService._internal();
  Database? _db;
  bool _isInitialized = false;

  factory LocalKanjiDictService() {
    return _instance;
  }

  LocalKanjiDictService._internal();

  Future<void> initialize() async {
    if (_isInitialized) {
      Logger.log('$_serviceName already initialized');
      return;
    }

    try {
      Logger.log('Initializing $_serviceName...');
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      Logger.log('$_serviceName - Database path: $path');

      // Delete existing database if it exists
      await deleteDatabase(path);
      Logger.log('$_serviceName - Deleted existing database');

      // Create new database
      Logger.log('$_serviceName - Opening database...');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          Logger.log('$_serviceName - Creating new KanjiDict database...');
          await db.execute('''
            CREATE TABLE $_tableName (
              literal TEXT PRIMARY KEY,
              meanings TEXT NOT NULL,
              readings TEXT NOT NULL,
              grade INTEGER,
              jlpt INTEGER,
              stroke_count INTEGER
            )
          ''');
          Logger.log('$_serviceName - Database schema created successfully');

          await _loadInitialData(db);
        },
        onOpen: (db) {
          Logger.log('$_serviceName - Database opened successfully');
        },
      );

      // Verify database was created and has data
      final count = Sqflite.firstIntValue(
          await _db!.rawQuery('SELECT COUNT(*) FROM $_tableName'));
      Logger.log('$_serviceName - Database contains $count entries');

      if (count == 0) {
        throw Exception('Database was created but contains no entries');
      }

      _isInitialized = true;
      Logger.log('$_serviceName initialized successfully');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to initialize $_serviceName',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to initialize kanji dictionary: $e');
    }
  }

  Future<void> _loadInitialData(Database db) async {
    try {
      Logger.log('$_serviceName - Loading initial kanji data...');
      String jsonString;
      try {
        final ByteData data =
            await rootBundle.load('assets/kanjidict/dictionary.json');
        jsonString = utf8.decode(data.buffer.asUint8List());
        Logger.log('Successfully loaded dictionary.json');
      } catch (e) {
        Logger.error('Failed to load dictionary.json', error: e);
        throw Exception('Failed to load dictionary.json: $e');
      }

      final Map<String, dynamic> entries;
      try {
        entries = json.decode(jsonString);
        Logger.log('Successfully parsed dictionary.json');
      } catch (e) {
        Logger.error('Failed to parse dictionary.json', error: e);
        throw Exception('Failed to parse dictionary.json: $e');
      }
      Logger.log(
          '$_serviceName - Parsed ${entries.length} kanji entries from JSON');

      await db.transaction((txn) async {
        Logger.log(
            '$_serviceName - Starting database transaction for initial data load');
        final batch = txn.batch();
        var count = 0;

        entries.forEach((key, value) {
          batch.insert(_tableName, {
            'literal': value['literal'],
            'meanings': json.encode(value['meanings']),
            'readings': json.encode(value['readings']),
            'grade': value['grade'],
            'jlpt': value['jlpt'],
            'stroke_count': value['stroke_count'],
          });
          count++;
          if (count % 1000 == 0) {
            Logger.log('$_serviceName - Processed $count entries...');
          }
        });

        await batch.commit(noResult: true);
        Logger.log(
            '$_serviceName - Successfully loaded $count kanji entries into database');
      });

      Logger.log('$_serviceName - Initial kanji data loaded successfully');
    } catch (e) {
      Logger.error('Failed to load initial kanji data', error: e);
      throw Exception('Failed to load kanji data: $e');
    }
  }

  Future<KanjiDictEntry?> lookupKanji(String kanji) async {
    if (!_isInitialized || _db == null) {
      Logger.error('Kanji dictionary not initialized');
      throw Exception('Kanji dictionary not initialized');
    }

    try {
      Logger.log('$_serviceName - Looking up kanji: $kanji');
      final List<Map<String, dynamic>> results = await _db!.query(
        _tableName,
        where: 'literal = ?',
        whereArgs: [kanji],
      );

      Logger.log('\n=== KanjiDict Lookup Results ===');
      Logger.log('Kanji: $kanji');
      Logger.log('Found ${results.length} entries');

      if (results.isEmpty) {
        Logger.log('No results found');
        return null;
      }

      final row = results.first;
      Logger.log('\nDetails:');
      Logger.log('Grade: ${row['grade']}');
      Logger.log('JLPT Level: ${row['jlpt']}');
      Logger.log('Stroke Count: ${row['stroke_count']}');

      final meanings = json.decode(row['meanings'] as String);
      Logger.log('Meanings: ${meanings.join(", ")}');

      final readings = json.decode(row['readings'] as String);
      Logger.log('On Readings: ${(readings['on'] as List).join(", ")}');
      Logger.log('Kun Readings: ${(readings['kun'] as List).join(", ")}');
      final entry = KanjiDictEntry(
        literal: row['literal'] as String,
        meanings: List<String>.from(json.decode(row['meanings'] as String)),
        readings: Map<String, List<String>>.from(
          json.decode(row['readings'] as String).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
        ),
        grade: row['grade'] as int?,
        jlpt: row['jlpt'] as int?,
        strokeCount: row['stroke_count'] as int?,
      );

      Logger.log('$_serviceName - Successfully looked up kanji: $kanji');
      return entry;
    } catch (e) {
      Logger.error('Failed to lookup kanji: $kanji', error: e);
      throw Exception('Failed to lookup kanji: $e');
    }
  }

  Future<void> recreateDatabase() async {
    Logger.log('$_serviceName - Recreating KanjiDict database...');
    if (_db != null) {
      await _db!.close();
      Logger.log('$_serviceName - Closed existing database connection');
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    await deleteDatabase(path);
    Logger.log('$_serviceName - Deleted existing database at: $path');
    _isInitialized = false;

    await initialize();
    Logger.log('$_serviceName - KanjiDict database recreated successfully');
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      _isInitialized = false;
    }
  }
}
