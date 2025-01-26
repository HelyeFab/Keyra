import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:Keyra/core/utils/logger.dart';

Future<void> testWanikaniKanji(String kanji) async {
  final apiKey = Platform.environment['WANIKANI_API_KEY'];
  if (apiKey == null) {
    Logger.log('WANIKANI_API_KEY not found in environment variables');
    return;
  }

  try {
    // First, search for the kanji subject
    final response = await http.get(
      Uri.parse('https://api.wanikani.com/v2/subjects?types=kanji&slugs=$kanji'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Wanikani-Revision': '20170710',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Logger.log('\n=== Wanikani API Results for kanji: $kanji ===');
      
      if (data['data'] != null && data['data'].isNotEmpty) {
        final kanjiData = data['data'][0]['data'];
        
        Logger.log('\nMeanings:');
        final meanings = kanjiData['meanings'] as List;
        for (var meaning in meanings) {
          Logger.log('- ${meaning['meaning']} (primary: ${meaning['primary']})');
        }

        Logger.log('\nReadings:');
        final readings = kanjiData['readings'] as List;
        for (var reading in readings) {
          Logger.log('- ${reading['reading']} (type: ${reading['type']}, primary: ${reading['primary']})');
        }

        if (kanjiData['meaning_mnemonic'] != null) {
          Logger.log('\nMeaning Mnemonic:');
          Logger.log(kanjiData['meaning_mnemonic']);
        }

        if (kanjiData['reading_mnemonic'] != null) {
          Logger.log('\nReading Mnemonic:');
          Logger.log(kanjiData['reading_mnemonic']);
        }

        Logger.log('\nLevel: ${kanjiData['level']}');
        Logger.log('Component Subject IDs: ${kanjiData['component_subject_ids']}');
        Logger.log('Amalgamation Subject IDs: ${kanjiData['amalgamation_subject_ids']}');
      } else {
        Logger.log('No data found for kanji: $kanji');
      }
      Logger.log('\n=== End of Wanikani Results ===');
    } else {
      Logger.error('Failed to fetch data', error: 'Status code: ${response.statusCode}');
      Logger.error('Response body', error: response.body);
    }
  } catch (e) {
    Logger.error('Failed to fetch Wanikani data', error: e);
  }
}

void main() async {
  final apiKey = Platform.environment['WANIKANI_API_KEY'];
  if (apiKey == null) {
    Logger.log('Please set the WANIKANI_API_KEY environment variable');
    return;
  }
  await testWanikaniKanji('色');
}
