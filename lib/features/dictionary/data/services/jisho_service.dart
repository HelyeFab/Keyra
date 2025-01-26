import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/utils/logger.dart';

class JishoService {
  static const String _baseUrl = 'https://jisho.org/api/v1/search/words';
  final _client = http.Client();
  bool _isInitialized = false;
  
  /// Whether the service has been initialized
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> close() async {
    _client.close();
    _isInitialized = false;
  }

  Future<Map<String, dynamic>?> getJishoData(String word) async {
    if (!_isInitialized) {
      Logger.error('JishoService not initialized', error: 'Call initialize() first');
      return null;
    }

    if (word.isEmpty) {
      Logger.error('Invalid word', error: 'Word cannot be empty');
      return null;
    }

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl?keyword=${Uri.encodeComponent(word)}'),
      );

      if (response.statusCode != 200) {
        Logger.error('Jisho API error', error: '${response.statusCode} - ${response.body}');
        return null;
      }

      Map<String, dynamic> data;
      try {
        data = json.decode(utf8.decode(response.bodyBytes));
      } catch (e) {
        Logger.error('Failed to parse Jisho response', error: e);
        return null;
      }

      if (data['data'] == null || data['data'].isEmpty) {
        Logger.log('No results found for word: $word');
        return null;
      }

      final firstResult = data['data'][0];
      if (firstResult['japanese'] == null || firstResult['japanese'].isEmpty ||
          firstResult['senses'] == null || firstResult['senses'].isEmpty) {
        Logger.error('Invalid Jisho data structure', error: 'Missing required fields');
        return null;
      }

      // Log Jisho results in a structured format
      Logger.log('\n=== Jisho Dictionary Results ===');
      Logger.log('Word: ${firstResult['japanese'][0]['word'] ?? word}');
      Logger.log('Reading: ${firstResult['japanese'][0]['reading'] ?? ''}');
      Logger.log('Jisho Meanings:');
      for (var sense in firstResult['senses']) {
        for (var def in sense['english_definitions']) {
          Logger.log('• $def');
        }
      }
      if (firstResult['senses'][0]['parts_of_speech'].isNotEmpty) {
        Logger.log('Parts of Speech: ${firstResult['senses'][0]['parts_of_speech'].join(', ')}');
      }
      if (firstResult['senses'][0]['tags'].isNotEmpty) {
        Logger.log('Tags: ${firstResult['senses'][0]['tags'].join(', ')}');
      }
      if (firstResult['senses'][0]['info'].isNotEmpty) {
        Logger.log('Info: ${firstResult['senses'][0]['info'].join(', ')}');
      }
      Logger.log('=== End of Results ===\n');

      final japanese = firstResult['japanese'][0];
      final senses = firstResult['senses'][0];

      if (senses['english_definitions'] == null) {
        Logger.error('Invalid Jisho data structure', error: 'Missing english_definitions');
        return null;
      }

      // Convert meanings to objects with primary flag
      final meanings = (senses['english_definitions'] as List<dynamic>).asMap().entries.map((entry) {
        return {
          'meaning': entry.value,
          'primary': entry.key == 0, // First meaning is primary
        };
      }).toList();

      return {
        'reading': japanese['reading'] ?? japanese['word'],
        'meanings': meanings,
        'partsOfSpeech': senses['parts_of_speech'] as List<dynamic>,
      };
    } catch (e) {
      Logger.error('Failed to fetch Jisho data', error: e);
      return null;
    }
  }
}
