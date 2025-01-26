import 'package:characters/characters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Keyra/core/utils/logger.dart';

class WanikaniService {
  static Future<Map<String, dynamic>?> getKanjiData(String word) async {
    final apiKey = dotenv.env['WANIKANI_API_KEY'];
    if (apiKey == null) {
      Logger.error('WaniKani API key not found in .env file', error: 'WANIKANI_API_KEY is missing');
      return null;
    }

    try {
      // Get first kanji character from word
      final firstKanji = word.characters.firstWhere(
        (char) => RegExp(r'[\u4e00-\u9faf]').hasMatch(char),
        orElse: () => '',
      );

      if (firstKanji.isEmpty) {
        Logger.log('No kanji found in word: $word, skipping WaniKani lookup');
        return null;
      }

      Logger.log('Found kanji in word, searching WaniKani for: $firstKanji');

      final response = await http.get(
        Uri.parse(
            'https://api.wanikani.com/v2/subjects?types=kanji&slugs=$firstKanji'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Wanikani-Revision': '20170710',
        },
      );

      Logger.log('WaniKani API response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        Logger.error('WaniKani API error', error: '${response.statusCode} - ${response.body}');
        return null;
      }

      final data = json.decode(response.body);
      if (data == null || data['data'] == null || data['data'].isEmpty) {
        Logger.log('No WaniKani data found for kanji: $firstKanji');
        return null;
      }

      final kanjiEntry = data['data'][0];
      if (kanjiEntry == null || kanjiEntry['data'] == null) {
        Logger.log('Invalid WaniKani data structure for kanji: $firstKanji');
        return null;
      }

      final kanjiData = kanjiEntry['data'];
      Logger.log('Found WaniKani data for kanji: $firstKanji');
      Logger.log('Level: ${kanjiData['level']}');

      return {
        'level': kanjiData['level'],
        'meanings': kanjiData['meanings']
            .where((m) => m['accepted_answer'] == true)
            .map((m) => {
                  'meaning': m['meaning'].toString(),
                  'primary': m == kanjiData['meanings'][0],
                })
            .toList(),
        'readings': kanjiData['readings']
            .where((r) => r['accepted_answer'] == true)
            .map((r) => {
                  'reading': r['reading'],
                  'type': r['type'],
                })
            .toList(),
        'meaning_mnemonic': kanjiData['meaning_mnemonic'],
        'reading_mnemonic': kanjiData['reading_mnemonic'],
        'componentSubjectIds': kanjiData['component_subject_ids'],
        'amalgamationSubjectIds': kanjiData['amalgamation_subject_ids'],
      };
    } catch (e, stackTrace) {
      Logger.error('Failed to fetch Wanikani data', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
