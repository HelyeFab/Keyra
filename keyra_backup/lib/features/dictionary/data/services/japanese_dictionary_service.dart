import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/features/dictionary/data/services/wanikani_service.dart';

class JapaneseDictionaryService {
  static final _instance = JapaneseDictionaryService._internal();
  factory JapaneseDictionaryService() => _instance;
  JapaneseDictionaryService._internal();

  final String _gooApiUrl = 'https://labs.goo.ne.jp/api/hiragana';
  final String _jishoApiUrl = 'https://jisho.org/api/v1/search/words';
  final WanikaniService _wanikaniService = WanikaniService();

  // Always return true since we don't need initialization anymore
  bool get isInitialized => true;

  // Empty initialize method to maintain compatibility
  Future<void> initialize() async {}

  Future<String?> _getReading(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_gooApiUrl),
        body: {
          'app_id': ApiKeys.gooLabsApiKey,
          'sentence': text,
          'output_type': 'hiragana',
        },
      );

      if (response.statusCode == 200 && 
          response.body.isNotEmpty) {
        final data = json.decode(response.body);
        if (data['converted'] != null) {
          return data['converted'] as String;
        }
      }
    } catch (e) {
      debugPrint('Error getting reading: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getJishoData(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$_jishoApiUrl?keyword=$word'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final firstResult = data['data'][0];
          final japanese = firstResult['japanese'][0];
          final senses = firstResult['senses'] as List;

          // Extract all meanings with their metadata
          final meanings = <Map<String, dynamic>>[];
          for (final sense in senses) {
            final englishDefs = sense['english_definitions'] as List;
            final partsOfSpeech = sense['parts_of_speech'] as List;
            
            for (final def in englishDefs) {
              meanings.add({
                'meaning': def,
                'primary': false, // Jisho doesn't specify primary meanings
                'parts_of_speech': partsOfSpeech,
              });
            }
          }

          return {
            'reading': japanese['reading'],
            'meanings': meanings,
            'partsOfSpeech': senses[0]['parts_of_speech'] as List,
            'source': 'jisho',
          };
        }
      }
    } catch (e) {
      debugPrint('Error getting Jisho data: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> getDefinition(String word) async {
    try {
      debugPrint('Getting WaniKani data for: $word');
      
      // Get WaniKani data
      final wanikaniData = await _wanikaniService.getKanjiData(word);
      
      if (wanikaniData == null) {
        debugPrint('No WaniKani data found, falling back to Jisho');
        
        // Fall back to Jisho dictionary
        final jishoData = await _getJishoData(word);
        
        if (jishoData != null) {
          debugPrint('Found Jisho data');
          final result = {
            'word': word,
            'reading': jishoData['reading'],
            'meanings': jishoData['meanings'],
            'partsOfSpeech': jishoData['partsOfSpeech'],
            'source': 'jisho',
          };

          // If no reading from Jisho, try Goo Labs
          if (result['reading'] == null) {
            result['reading'] = await _getReading(word);
          }

          debugPrint('\n=== Final processed result (Jisho) ===');
          debugPrint('Word: ${result['word']}');
          debugPrint('Reading: ${result['reading']}');
          debugPrint('Meanings: ${result['meanings']}');
          debugPrint('Parts of Speech: ${result['partsOfSpeech']}');
          debugPrint('=== End of result ===\n');

          return result;
        }

        // If both WaniKani and Jisho fail, try to at least get a reading
        final reading = await _getReading(word);
        return {
          'word': word,
          'reading': reading,
          'meanings': [],
          'partsOfSpeech': [],
          'source': 'goo',
        };
      }

      // Process WaniKani data
      final readings = wanikaniData['readings'] as List<dynamic>?;
      String? reading;
      
      if (readings != null && readings.isNotEmpty) {
        // Find primary reading or use first reading
        Map<String, dynamic>? primaryReading;
        
        // First try to find a reading marked as primary
        for (final r in readings) {
          if (r is Map<String, dynamic>) {
            final isPrimary = r['primary'];
            if (isPrimary != null && isPrimary == true) {
              primaryReading = r;
              break;
            }
          }
        }
        
        // If no primary reading found, use the first valid reading
        if (primaryReading == null && readings.isNotEmpty) {
          final firstReading = readings.first;
          if (firstReading is Map<String, dynamic>) {
            primaryReading = firstReading;
          }
        }
        
        if (primaryReading != null && primaryReading.containsKey('reading')) {
          reading = primaryReading['reading']?.toString();
        }
      }
      
      reading ??= await _getReading(word);

      // Extract meanings with their metadata
      final meaningsData = wanikaniData['meanings'];
      final meanings = <Map<String, dynamic>>[];
      
      if (meaningsData != null && meaningsData is List<dynamic>) {
        for (final m in meaningsData) {
          if (m is Map<String, dynamic>) {
            meanings.add({
              'meaning': m['meaning']?.toString() ?? '',
              'primary': m['primary'] ?? false,
              'parts_of_speech': ['kanji'], // WaniKani specific
            });
          }
        }
      }

      // Sort readings by type (kunyomi first, then onyomi)
      final sortedReadings = <Map<String, dynamic>>[];
      if (readings != null) {
        for (final reading in readings) {
          if (reading is Map<String, dynamic>) {
            sortedReadings.add(reading);
          }
        }
        sortedReadings.sort((a, b) {
          final aType = a['type']?.toString() ?? '';
          final bType = b['type']?.toString() ?? '';
          if (aType == bType) {
            final bPrimary = b['primary'];
            final aPrimary = a['primary'];
            if (bPrimary == true) return 1;
            if (aPrimary == true) return -1;
            return 0;
          }
          return aType == 'kunyomi' ? -1 : 1;
        });
      }

      // Extract level data
      final level = wanikaniData['level']?.toString() ?? '1';

      final result = {
        'word': word,
        'reading': reading,
        'meanings': meanings,
        'partsOfSpeech': ['kanji'],
        'wanikani': {
          ...wanikaniData,
          'readings': sortedReadings,
          'level': level,
        },
        'source': 'wanikani',
      };
      
      debugPrint('\n=== Final processed result (WaniKani) ===');
      debugPrint('Word: ${result['word']}');
      debugPrint('Reading: ${result['reading']}');
      debugPrint('Meanings: ${result['meanings']}');
      debugPrint('Parts of Speech: ${result['partsOfSpeech']}');
      if (result['source'] == 'wanikani') {
        final wanikani = result['wanikani'] as Map<String, dynamic>;
        debugPrint('Level: ${wanikani['level']}');
      }
      debugPrint('=== End of result ===\n');
      
      return result;
    } catch (e) {
      debugPrint('Error getting definition: $e');
      return {
        'word': word,
        'meanings': [],
        'partsOfSpeech': [],
        'source': 'error',
      };
    }
  }
}
