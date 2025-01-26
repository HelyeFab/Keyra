import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/dictionary/data/services/japanese_dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/services/jisho_service.dart';

class CombinedJapaneseDictionaryResult {
  final Map<String, dynamic>? jmdictResult;
  final Map<String, dynamic>? jishoResult;
  final Map<String, dynamic>? kanjiInfo;

  CombinedJapaneseDictionaryResult({
    this.jmdictResult,
    this.jishoResult,
    this.kanjiInfo,
  });

  bool get hasResults => jmdictResult != null || jishoResult != null;
}

class CombinedJapaneseDictionaryService {
  final JapaneseDictionaryService _jmdictService;
  final JishoService _jishoService;
  bool _isInitialized = false;

  CombinedJapaneseDictionaryService()
      : _jmdictService = JapaneseDictionaryService(),
        _jishoService = JishoService();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _jmdictService.initialize();
      await _jishoService.initialize();
      _isInitialized = true;
      Logger.log('CombinedJapaneseDictionaryService initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize CombinedJapaneseDictionaryService', error: e);
      rethrow;
    }
  }

  Future<void> close() async {
    await _jmdictService.close();
    await _jishoService.close();
    _isInitialized = false;
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('CombinedJapaneseDictionaryService not initialized');
    }
  }

  Future<CombinedJapaneseDictionaryResult> getDefinition(String word) async {
    _checkInitialized();

    try {
      // Get JMDict results
      final jmdictResult = await _jmdictService.getDefinition(word);
      
      // Get Jisho results
      final jishoResult = await _jishoService.getJishoData(word);

      // Get kanji info if available in JMDict result
      final kanjiInfo = jmdictResult?['kanjiInfo'];

      return CombinedJapaneseDictionaryResult(
        jmdictResult: jmdictResult,
        jishoResult: jishoResult,
        kanjiInfo: kanjiInfo,
      );
    } catch (e) {
      Logger.error('Error in CombinedJapaneseDictionaryService.getDefinition', error: e);
      rethrow;
    }
  }
}
