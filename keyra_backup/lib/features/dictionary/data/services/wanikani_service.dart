import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class WanikaniService {
  static final _instance = WanikaniService._internal();
  factory WanikaniService() => _instance;
  WanikaniService._internal();

  Future<Map<String, dynamic>?> getKanjiData(String word) async {
    final apiKey = dotenv.env['WANIKANI_API_KEY'];
    if (apiKey == null) {
      debugPrint('WANIKANI_API_KEY not found in .env file');
      return null;
    }

    try {
      // For compound words, try to get data for the first kanji character
      final firstKanji = RegExp(r'[\u4e00-\u9faf]').firstMatch(word)?.group(0);
      if (firstKanji == null) {
        debugPrint('No kanji found in word: $word');
        return null;
      }

      debugPrint('Searching WaniKani for kanji: $firstKanji');
      
      // First, get all subjects of type kanji
      final response = await http.get(
        Uri.parse('https://api.wanikani.com/v2/subjects'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Wanikani-Revision': '20170710',
        },
      );

      debugPrint('WaniKani response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['data'] != null && data['data'] is List) {
          // Find the kanji in the response
          final kanjiEntry = (data['data'] as List).firstWhere(
            (item) => 
              item['object'] == 'kanji' && 
              item['data']['characters'] == firstKanji,
            orElse: () => null,
          );

          if (kanjiEntry != null) {
            final kanjiData = kanjiEntry['data'];
            debugPrint('Found WaniKani data for kanji: $firstKanji');
            debugPrint('Kanji data: $kanjiData');

            return {
              'meanings': (kanjiData['meanings'] as List)
                  .map((m) => {
                        'meaning': m['meaning'],
                        'primary': m['primary'] ?? false,
                      })
                  .toList(),
              'readings': (kanjiData['readings'] as List)
                  .map((r) => {
                        'reading': r['reading'],
                        'type': r['type'],
                        'primary': r['primary'] ?? false,
                      })
                  .toList(),
              'meaning_mnemonic': kanjiData['meaning_mnemonic'],
              'reading_mnemonic': kanjiData['reading_mnemonic'],
              'level': kanjiData['level'],
            };
          } else {
            debugPrint('No matching kanji found in WaniKani data for: $firstKanji');
          }
        } else {
          debugPrint('Invalid data structure in WaniKani response');
        }
      } else {
        debugPrint('WaniKani API error: ${response.statusCode} - ${response.body}');
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error fetching Wanikani data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
}
