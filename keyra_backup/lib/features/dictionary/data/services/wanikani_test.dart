import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

Future<void> testWanikaniKanji(String kanji) async {
  final apiKey = Platform.environment['WANIKANI_API_KEY'];
  if (apiKey == null) {
    print('WANIKANI_API_KEY not found in environment variables');
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
      print('\n=== Wanikani API Results for kanji: $kanji ===');
      
      if (data['data'] != null && data['data'].isNotEmpty) {
        final kanjiData = data['data'][0]['data'];
        
        print('\nMeanings:');
        final meanings = kanjiData['meanings'] as List;
        for (var meaning in meanings) {
          print('- ${meaning['meaning']} (primary: ${meaning['primary']})');
        }

        print('\nReadings:');
        final readings = kanjiData['readings'] as List;
        for (var reading in readings) {
          print('- ${reading['reading']} (type: ${reading['type']}, primary: ${reading['primary']})');
        }

        if (kanjiData['meaning_mnemonic'] != null) {
          print('\nMeaning Mnemonic:');
          print(kanjiData['meaning_mnemonic']);
        }

        if (kanjiData['reading_mnemonic'] != null) {
          print('\nReading Mnemonic:');
          print(kanjiData['reading_mnemonic']);
        }

        print('\nLevel: ${kanjiData['level']}');
        print('Component Subject IDs: ${kanjiData['component_subject_ids']}');
        print('Amalgamation Subject IDs: ${kanjiData['amalgamation_subject_ids']}');
      } else {
        print('No data found for kanji: $kanji');
      }
      print('\n=== End of Wanikani Results ===');
    } else {
      print('Error: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error fetching Wanikani data: $e');
  }
}

void main() async {
  final apiKey = Platform.environment['WANIKANI_API_KEY'];
  if (apiKey == null) {
    print('Please set the WANIKANI_API_KEY environment variable');
    return;
  }
  await testWanikaniKanji('色');
}
