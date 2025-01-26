import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/dictionary/domain/models/jmdict_entry.dart';
import 'package:Keyra/features/dictionary/domain/models/example_sentence.dart';

class LocalJMDictService {
  static const String _serviceName = 'LocalJMDictService';
  static const String _dbName = 'jmdict.db';
  static const String _tableName = 'entries';
  static const int _dbVersion = 1; // Track database version
  Database? _db;
  bool _isInitialized = false;

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

      // Open the database with optimized settings
      Logger.log('$_serviceName - Opening database with optimized settings...');
      _db = await openDatabase(
        path,
        version: _dbVersion,
        onConfigure: (db) async {
          Logger.log('$_serviceName - Configuring database...');
          // Set performance optimizations first
          await db.rawQuery('PRAGMA journal_mode=DELETE');
          await db.rawQuery('PRAGMA synchronous=NORMAL');
          await db.rawQuery('PRAGMA cache_size=-2000');
          // Enable foreign keys
          await db.execute('PRAGMA foreign_keys=ON');
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          Logger.log('$_serviceName - Upgrading database from v$oldVersion to v$newVersion...');
          // Handle future schema upgrades here
          await recreateDatabase();
        },
        onCreate: (Database db, int version) async {
          Logger.log('$_serviceName - First run, creating database...');
          
          // Create main entries table
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              kanji TEXT,
              reading TEXT NOT NULL
            )
          ''');

          // Create meanings table
          await db.execute('''
            CREATE TABLE meanings (
              entry_id INTEGER,
              meaning TEXT NOT NULL,
              FOREIGN KEY(entry_id) REFERENCES $_tableName(id)
            )
          ''');

          // Create parts of speech table
          await db.execute('''
            CREATE TABLE parts_of_speech (
              entry_id INTEGER,
              part_of_speech TEXT NOT NULL,
              FOREIGN KEY(entry_id) REFERENCES $_tableName(id)
            )
          ''');

          // Create examples table
          await db.execute('''
            CREATE TABLE examples (
              entry_id INTEGER,
              japanese TEXT NOT NULL,
              english TEXT NOT NULL,
              FOREIGN KEY(entry_id) REFERENCES $_tableName(id)
            )
          ''');
          
          // Add optimized indexes for word lookups
          await db.execute('CREATE INDEX idx_kanji ON $_tableName(kanji) WHERE kanji IS NOT NULL');
          await db.execute('CREATE INDEX idx_reading ON $_tableName(reading)');
          await db.execute('CREATE INDEX idx_meanings_entry ON meanings(entry_id)');
          await db.execute('CREATE INDEX idx_pos_entry ON parts_of_speech(entry_id)');
          await db.execute('CREATE INDEX idx_examples_entry ON examples(entry_id)');
          
          Logger.log('$_serviceName - Database schema created successfully');

          // Load initial data from JSON asset
          await _loadInitialData(db);
        },
        onOpen: (db) {
          Logger.log('$_serviceName - Database opened successfully');
        },
      );

      // Verify database was created and has data
      final tables = await _db!.query('sqlite_master', 
        where: 'type = ?', 
        whereArgs: ['table']
      );
      Logger.log('$_serviceName - Database tables: ${tables.map((t) => t['name']).join(', ')}');

      // Check each required table exists and has data
      final tableChecks = await Future.wait([
        _db!.rawQuery('SELECT COUNT(*) FROM $_tableName'),
        _db!.rawQuery('SELECT COUNT(*) FROM meanings'),
        _db!.rawQuery('SELECT COUNT(*) FROM parts_of_speech'),
      ]);

      final counts = tableChecks.map((result) => Sqflite.firstIntValue(result) ?? 0).toList();
      Logger.log('$_serviceName - Table counts: entries=${counts[0]}, meanings=${counts[1]}, parts_of_speech=${counts[2]}');

      if (counts[0] == 0 || counts[1] == 0 || counts[2] == 0) {
        throw Exception('Database was created but tables are empty: entries=${counts[0]}, meanings=${counts[1]}, parts_of_speech=${counts[2]}');
      }

      _isInitialized = true;
      Logger.log('$_serviceName initialized successfully');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to initialize $_serviceName',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to initialize dictionary: $e');
    }
  }

  Future<void> _loadInitialData(Database db) async {
    try {
      Logger.log('$_serviceName - Loading initial dictionary data...');
      // Load the JSON file from assets
      // Load the JSON file from assets
      final ByteData data =
          await rootBundle.load('assets/jmdict/dictionary.json');
      final String jsonString = utf8.decode(data.buffer.asUint8List());
      Logger.log('Successfully loaded dictionary.json');

      final List<dynamic> entries = json.decode(jsonString);
      Logger.log(
          '$_serviceName - Parsed ${entries.length} dictionary entries from JSON');

      // Set memory settings before transaction
      await db.execute('PRAGMA temp_store=MEMORY');
      await db.rawQuery('PRAGMA mmap_size=268435456'); // 256MB memory map

      // Begin transaction for better performance
      var count = 0;
      await db.transaction((txn) async {
        Logger.log(
            '$_serviceName - Starting database transaction for initial data load');

        // First insert all entries and get their IDs
        var batch = txn.batch();
        for (final entry in entries) {
          batch.insert(_tableName, {
            'kanji': entry['kanji'],
            'reading': entry['reading'],
          });
        }
        final ids = await batch.commit();
        
        // Process related data in larger chunks for better performance
        const chunkSize = 25000; // Increased chunk size
        final totalChunks = (entries.length / chunkSize).ceil();
        
        for (var chunk = 0; chunk < totalChunks; chunk++) {
          final start = chunk * chunkSize;
          final end = (chunk + 1) * chunkSize;
          final currentChunk = entries.sublist(start, end > entries.length ? entries.length : end);
          
          batch = txn.batch();
          
          // Process each entry in the chunk
          for (var i = 0; i < currentChunk.length; i++) {
            final entry = currentChunk[i];
            final id = ids[start + i] as int;
            
            // Add all related data to batch
            final batchSize = entry['meanings'].length + 
                            entry['parts_of_speech'].length + 
                            (entry['examples']?.length ?? 0);
            
            // Commit batch if it would get too large
            if (batchSize > 5000) { // Increased batch size threshold
              await batch.commit(noResult: true);
              batch = txn.batch();
            }
            
            // Add all related data to batch
            for (final meaning in entry['meanings']) {
              batch.insert('meanings', {
                'entry_id': id,
                'meaning': meaning,
              });
            }
            
            for (final pos in entry['parts_of_speech']) {
              batch.insert('parts_of_speech', {
                'entry_id': id,
                'part_of_speech': pos,
              });
            }
            
            if (entry['examples'] != null) {
              for (final example in entry['examples']) {
                batch.insert('examples', {
                  'entry_id': id,
                  'japanese': example['japanese'],
                  'english': example['english'],
                });
              }
            }
          }
          
          await batch.commit(noResult: true);
          count += currentChunk.length;
          Logger.log('$_serviceName - Processed $count/${entries.length} entries (${((count/entries.length)*100).toStringAsFixed(1)}%)...');
          
          // Release memory after each chunk
          await txn.execute('PRAGMA shrink_memory');
          await Future.delayed(const Duration(milliseconds: 100));
        }
        Logger.log(
            '$_serviceName - Successfully loaded $count dictionary entries into database');
      });

      Logger.log('$_serviceName - Initial dictionary data loaded successfully');
    } catch (e) {
      Logger.error('Failed to load initial dictionary data', error: e);
      throw Exception('Failed to load dictionary data: $e');
    }
  }

  Future<List<JMDictEntry>> lookupWord(String word) async {
    if (!_isInitialized || _db == null) {
      throw Exception('Dictionary not initialized');
    }

    try {
      // First get matching entries with better error handling
      Logger.log('$_serviceName - Looking up word: $word');
      
      // Try exact match first
      var entries = await _db!.rawQuery('''
        SELECT e.id, e.kanji, e.reading,
               GROUP_CONCAT(DISTINCT m.meaning) as meanings,
               GROUP_CONCAT(DISTINCT p.part_of_speech) as parts_of_speech
        FROM $_tableName e
        INNER JOIN meanings m ON m.entry_id = e.id
        INNER JOIN parts_of_speech p ON p.entry_id = e.id
        WHERE e.kanji = ? OR e.reading = ?
        GROUP BY e.id
        LIMIT 5
      ''', [word, word]);

      // If no results, try without particles
      if (entries.isEmpty) {
        final baseWord = word.replaceAll(RegExp(r'[のはをがでにと]$'), '');
        if (baseWord != word) {
          Logger.log('$_serviceName - No exact match found, trying without particles: $baseWord');
          entries = await _db!.rawQuery('''
            SELECT e.id, e.kanji, e.reading,
                   GROUP_CONCAT(DISTINCT m.meaning) as meanings,
                   GROUP_CONCAT(DISTINCT p.part_of_speech) as parts_of_speech
            FROM $_tableName e
            INNER JOIN meanings m ON m.entry_id = e.id
            INNER JOIN parts_of_speech p ON p.entry_id = e.id
            WHERE e.kanji = ? OR e.reading = ?
            GROUP BY e.id
            LIMIT 5
          ''', [baseWord, baseWord]);
        }
      }

      // If still no results, try partial match
      if (entries.isEmpty) {
        Logger.log('$_serviceName - No exact matches found, trying partial match');
        entries = await _db!.rawQuery('''
          SELECT e.id, e.kanji, e.reading,
                 GROUP_CONCAT(DISTINCT m.meaning) as meanings,
                 GROUP_CONCAT(DISTINCT p.part_of_speech) as parts_of_speech
          FROM $_tableName e
          INNER JOIN meanings m ON m.entry_id = e.id
          INNER JOIN parts_of_speech p ON p.entry_id = e.id
          WHERE (e.kanji LIKE ? || '%' OR e.reading LIKE ? || '%')
          GROUP BY e.id
          LIMIT 5
        ''', [word, word]);
      }

      Logger.log('$_serviceName - Found ${entries.length} entries');

      if (entries.isEmpty) {
        return [];
      }

      // Then get examples in a separate query
      return Future.wait(entries.map((row) async {
        final examples = await _db!.query(
          'examples',
          where: 'entry_id = ?',
          whereArgs: [row['id']],
        );

        return JMDictEntry(
          kanji: row['kanji'] as String?,
          reading: row['reading'] as String,
          meanings: row['meanings'] != null ? (row['meanings'] as String).split(',') : [],
          partsOfSpeech: row['parts_of_speech'] != null ? (row['parts_of_speech'] as String).split(',') : [],
          examples: examples.map((e) => ExampleSentence(
            japanese: e['japanese'] as String,
            english: e['english'] as String,
          )).toList(),
        );
      }));
    } catch (e) {
      Logger.error('Failed to lookup word: $word', error: e);
      throw Exception('Failed to lookup word: $e');
    }
  }

  Future<void> recreateDatabase() async {
    Logger.log('$_serviceName - Recreating JMdict database...');
    if (_db != null) {
      await _db!.close();
      Logger.log('$_serviceName - Closed existing database connection');
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Delete existing database
    await deleteDatabase(path);
    Logger.log('$_serviceName - Deleted existing database at: $path');
    _isInitialized = false;

    // Reinitialize
    await initialize();
    Logger.log('$_serviceName - JMdict database recreated successfully');
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      _isInitialized = false;
    }
  }
}
