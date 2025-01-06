import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  
  TTSService._internal() {
    _setupAudioPlayer();
  }

  TexttospeechApi? _ttsApi;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentText;
  BookLanguage? _currentLanguage;
  File? _currentAudioFile;
  Function? _onComplete;
  final _audioPlayerStateController = StreamController<bool>.broadcast();

  Stream<bool> get audioPlayerState => _audioPlayerStateController.stream;

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _isPlaying = true;
          _audioPlayerStateController.add(true);
          break;
        case PlayerState.paused:
        case PlayerState.stopped:
        case PlayerState.completed:
        case PlayerState.disposed:
          _isPlaying = false;
          _audioPlayerStateController.add(false);
          break;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioPlayerStateController.close();
  }

  Future<void> init() async {
    try {
      // Load credentials from assets
      final credentialsJson = await rootBundle.loadString('assets/config/google_tts_credentials.json');
      final credentials = ServiceAccountCredentials.fromJson(jsonDecode(credentialsJson));

      // Get an HTTP client with authentication
      final client = await clientViaServiceAccount(
        credentials,
        [TexttospeechApi.cloudPlatformScope],
      );

      // Create the Text-to-Speech API client
      _ttsApi = TexttospeechApi(client);

      await _audioPlayer.setVolume(1.0);
      debugPrint('TTS: Initialized successfully');
    } catch (e) {
      debugPrint('TTS Init Error: $e');
    }
  }

  AudioConfig _getAudioConfig(String languageCode) {
    // Base speaking rate is 1.0, so 0.9 is 90% speed
    final speakingRate = languageCode == 'ja-JP' ? 0.9 : 1.0;
    
    return AudioConfig(
      audioEncoding: 'MP3',
      speakingRate: speakingRate,
      pitch: 0.0,
      volumeGainDb: 0.0,
    );
  }

  Future<void> speak(String text, BookLanguage language, {Function? onComplete}) async {
    try {
      if (_ttsApi == null) {
        debugPrint('TTS: Not initialized');
        return;
      }

      _onComplete = onComplete;

      final languageCode = _getLanguageCode(language);
      debugPrint('TTS: Attempting to speak text in ${language.displayName} ($languageCode): ${text.substring(0, min(50, text.length))}...');
      
      // Always stop current playback and cleanup before starting new audio
      await stop();

      _currentText = text;
      _currentLanguage = language;

      final voice = await _getVoice(languageCode);
      debugPrint('TTS: Selected voice $voice for ${language.displayName}');
      
      final input = SynthesisInput(text: text);
      final voiceParams = VoiceSelectionParams(
        languageCode: languageCode,
        name: voice,
      );
      
      // Get language-specific audio configuration
      final audioConfig = _getAudioConfig(languageCode);

      final request = SynthesizeSpeechRequest(
        input: input,
        voice: voiceParams,
        audioConfig: audioConfig,
      );

      final response = await _ttsApi!.text.synthesize(request);

      if (response.audioContent != null) {
        // Save audio content to temporary file
        final tempDir = await getTemporaryDirectory();
        _currentAudioFile = File('${tempDir.path}/tts_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
        await _currentAudioFile!.writeAsBytes(base64Decode(response.audioContent!));

        // Create a new player for each playback to avoid state issues
        await _audioPlayer.dispose();
        _audioPlayer = AudioPlayer();
        _setupAudioPlayer();
        await _audioPlayer.setVolume(1.0);

        // Set playing state before starting playback
        _isPlaying = true;
        _audioPlayerStateController.add(true);
        
        await _audioPlayer.play(DeviceFileSource(_currentAudioFile!.path));
        debugPrint('TTS: Started playing audio in ${language.displayName} (${languageCode == 'ja-JP' ? '90% speed' : 'normal speed'})');

        // Clean up when playback completes normally
        _audioPlayer.onPlayerComplete.listen((_) async {
          debugPrint('TTS: Finished playing audio in ${language.displayName}');
          await _cleanupAudioFile();
          _onComplete?.call();
          _onComplete = null;
        });
      } else {
        debugPrint('TTS: Failed to get audio content');
        _onComplete?.call();
        _onComplete = null;
      }
    } catch (e) {
      debugPrint('TTS Speak Error: $e');
      // Reset state and cleanup on error
      await _cleanupAudioFile();
      _currentText = null;
      _currentLanguage = null;
      _isPlaying = false;
      _onComplete?.call();
      _onComplete = null;
    }
  }

  Future<void> _cleanupAudioFile() async {
    if (_currentAudioFile != null) {
      try {
        if (await _currentAudioFile!.exists()) {
          await _currentAudioFile!.delete();
          debugPrint('TTS: Cleaned up audio file');
        }
      } catch (e) {
        debugPrint('TTS: Cleanup error: $e');
      }
      _currentAudioFile = null;
    }
  }

  Future<void> pause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
        _audioPlayerStateController.add(false);
        debugPrint('TTS: Paused playback in ${_currentLanguage?.displayName ?? "unknown language"}');
      }
    } catch (e) {
      debugPrint('TTS Pause Error: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (!_isPlaying && _currentText != null && _currentLanguage != null) {
        await _audioPlayer.resume();
        _isPlaying = true;
        _audioPlayerStateController.add(true);
        debugPrint('TTS: Resumed playback in ${_currentLanguage?.displayName ?? "unknown language"}');
      }
    } catch (e) {
      debugPrint('TTS Resume Error: $e');
    }
  }

  Future<void> stop() async {
    try {
      final previousLanguage = _currentLanguage?.displayName;
      
      // Force stop any ongoing playback
      await _audioPlayer.stop();
      
      // Dispose the current player and create a new one
      await _audioPlayer.dispose();
      _audioPlayer = AudioPlayer();
      _setupAudioPlayer();
      await _audioPlayer.setVolume(1.0);
      
      // Clean up any existing audio file
      await _cleanupAudioFile();
      
      // Reset all state and notify listeners
      _isPlaying = false;
      _audioPlayerStateController.add(false);
      _currentText = null;
      _currentLanguage = null;
      
      // Notify completion if there was a callback
      _onComplete?.call();
      _onComplete = null;
      
      debugPrint('TTS: Stopped playback${previousLanguage != null ? " in $previousLanguage" : ""} and reset state');
    } catch (e) {
      debugPrint('TTS Stop Error: $e');
      // Ensure a new player is created even if there's an error
      _audioPlayer = AudioPlayer();
      _setupAudioPlayer();
      await _audioPlayer.setVolume(1.0);
      _onComplete?.call();
      _onComplete = null;
    }
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'ja':
        return 'ja-JP';
      case 'en':
        return 'en-GB'; 
      case 'es':
        return 'es-ES';
      case 'it':
        return 'it-IT';
      case 'fr':
        return 'fr-FR';
      case 'de':
        return 'de-DE';
      default:
        return 'en-GB'; 
    }
  }

  Future<String> _getVoice(String languageCode) async {
    if (_ttsApi == null) {
      throw Exception('TTS not initialized');
    }

    final voices = await _ttsApi!.voices.list($fields: 'voices');
    
    // Get all voices that exactly match the requested language code
    final matchingVoices = voices.voices?.where(
      (v) => v.languageCodes != null && 
             v.languageCodes!.contains(languageCode) && 
             v.name != null &&
             v.name!.startsWith(languageCode)  // Ensure voice name starts with correct language code
    ).toList() ?? [];

    if (matchingVoices.isEmpty) {
      debugPrint('TTS: No voices found for language $languageCode');
      throw Exception('No voices found for language $languageCode');
    }

    // Define preferred voices for each language
    final preferredVoices = {
      'en-GB': ['en-GB-Neural2-B', 'en-GB-Wavenet-B', 'en-GB-Standard-B'], // Male voice
      'ja-JP': ['ja-JP-Neural2-D', 'ja-JP-Wavenet-D', 'ja-JP-Standard-D'], // Male voice
      'es-ES': ['es-ES-Neural2-C', 'es-ES-Wavenet-C', 'es-ES-Standard-C'], // Female voice
      'it-IT': ['it-IT-Neural2-A', 'it-IT-Wavenet-A', 'it-IT-Standard-A'], // Female voice
      'fr-FR': ['fr-FR-Neural2-B', 'fr-FR-Wavenet-B', 'fr-FR-Standard-B'], // Male voice
      'de-DE': ['de-DE-Neural2-B', 'de-DE-Wavenet-B', 'de-DE-Standard-B'], // Male voice
    };

    // Try to find preferred voices first
    if (preferredVoices.containsKey(languageCode)) {
      for (final voiceName in preferredVoices[languageCode]!) {
        final voice = matchingVoices.firstWhere(
          (v) => v.name == voiceName,
          orElse: () => matchingVoices.first,
        );
        if (voice.name == voiceName) {
          return voice.name!;
        }
      }
    }

    // Find the best quality voice for the language
    // Priority: Neural2 > Wavenet > Standard
    final voice = matchingVoices.firstWhere(
      (v) => v.name != null && v.name!.contains('Neural2'),
      orElse: () => matchingVoices.firstWhere(
        (v) => v.name != null && v.name!.contains('Wavenet'),
        orElse: () => matchingVoices.firstWhere(
          (v) => v.name != null && v.name!.startsWith(languageCode),
          orElse: () {
            debugPrint('TTS: No suitable voice found for $languageCode');
            throw Exception('No suitable voice found for language $languageCode');
          },
        ),
      ),
    );

    debugPrint('TTS: Selected voice ${voice.name} for language $languageCode');
    return voice.name!;
  }

  bool get isPlaying => _isPlaying;
}
