import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/core/utils/logger.dart';

class TTSService {
  AudioPlayer? _audioPlayer;
  File? _currentAudioFile;
  BookLanguage? _currentLanguage;
  VoidCallback? _onComplete;
  final _audioPlayerStateController = BehaviorSubject<bool>.seeded(false);
  double _speedFactor = 1.0;
  bool _isPlaying = false;
  String? _currentText;

  Stream<bool> get audioPlayerState => _audioPlayerStateController.stream;

  void setSpeedFactor(double factor) {
    _speedFactor = factor.clamp(0.5, 1.0);
    if (_audioPlayer != null) {
      _audioPlayer!.setPlaybackRate(_speedFactor);
    }
    Logger.log('TTS: Set speed factor to $_speedFactor');
  }

  Future<void> init() async {
    try {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.onPlayerComplete.listen((_) {
        _audioPlayerStateController.add(false);
        _isPlaying = false;
        _onComplete?.call();
      });
      Logger.log('TTS: Initialized successfully');
    } catch (e) {
      Logger.error('TTS Init Error', error: e);
    }
  }

  Future<void> speak(String text, BookLanguage language, {VoidCallback? onComplete}) async {
    try {
      if (_audioPlayer == null) {
        Logger.log('TTS: Not initialized');
        return;
      }

      // Stop any existing playback
      await stop();

      _currentLanguage = language;
      _currentText = text;
      _onComplete = onComplete;
      _isPlaying = true;

      final languageCode = _getLanguageCode(language);
      Logger.log('TTS: Attempting to speak text in ${language.displayName} ($languageCode) at speed ${_speedFactor}x: ${text.substring(0, min(50, text.length))}...');

      // Split text into sentences and words for more natural pauses
      final sentences = text.split(RegExp(r'[.!?]+'));
      
      for (final sentence in sentences) {
        if (!_isPlaying) break;
        if (sentence.trim().isEmpty) continue;

        final url = Uri.parse(
          'https://translate.google.com/translate_tts'
          '?ie=UTF-8'
          '&q=${Uri.encodeComponent(sentence.trim())}'
          '&tl=$languageCode'
          '&client=tw-ob'
          '&ttsspeed=1'
        ).toString();

        try {
          // Get temporary directory to store audio file
          final tempDir = await getTemporaryDirectory();
          final tempPath = '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3';
          _currentAudioFile = File(tempPath);

          // Download audio file
          final response = await HttpClient().getUrl(Uri.parse(url));
          final audioData = await response.close();
          await _currentAudioFile!.writeAsBytes(await audioData.expand((x) => x).toList());

          // Play the audio file and wait for completion
          if (_isPlaying) {
            await _audioPlayer!.play(DeviceFileSource(_currentAudioFile!.path));
            await _audioPlayer!.setPlaybackRate(_speedFactor);
            _audioPlayerStateController.add(true);

            // Wait for this sentence to complete before proceeding
            await _audioPlayer!.onPlayerComplete.first;

            // Clean up the temporary file
            if (_currentAudioFile != null && await _currentAudioFile!.exists()) {
              await _currentAudioFile!.delete();
            }
          }
        } catch (e) {
          Logger.error('TTS Sentence Error', error: e);
          continue; // Try next sentence if this one fails
        }
      }

      // Playback completed normally
      if (_isPlaying) {
        _isPlaying = false;
        _audioPlayerStateController.add(false);
        _onComplete?.call();
        Logger.log('TTS: Completed playback in ${language.displayName}');
      }

    } catch (e) {
      Logger.error('TTS Speak Error', error: e);
      _cleanupAudioFile();
      _isPlaying = false;
      _onComplete?.call();
      _audioPlayerStateController.add(false);
    }
  }

  Future<void> pause() async {
    try {
      _isPlaying = false;
      await _audioPlayer?.pause();
      _audioPlayerStateController.add(false);
      Logger.log('TTS: Paused playback');
    } catch (e) {
      Logger.error('TTS Pause Error', error: e);
    }
  }

  Future<void> resume() async {
    try {
      _isPlaying = true;
      await _audioPlayer?.resume();
      await _audioPlayer?.setPlaybackRate(_speedFactor);
      _audioPlayerStateController.add(true);
      Logger.log('TTS: Resumed playback');
    } catch (e) {
      Logger.error('TTS Resume Error', error: e);
    }
  }

  Future<void> stop() async {
    try {
      _isPlaying = false;
      await _audioPlayer?.stop();
      await _cleanupAudioFile();
      _audioPlayerStateController.add(false);
      Logger.log('TTS: Stopped playback and reset state');
    } catch (e) {
      Logger.error('TTS Stop Error', error: e);
    }
  }

  Future<void> _cleanupAudioFile() async {
    try {
      if (_currentAudioFile != null && await _currentAudioFile!.exists()) {
        await _currentAudioFile!.delete();
        _currentAudioFile = null;
        Logger.log('TTS: Cleaned up audio file');
      }
    } catch (e) {
      Logger.error('TTS: Cleanup error', error: e);
    }
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'ja':
        return 'ja-JP';
      case 'en':
        return 'en-US';
      default:
        return language.code;
    }
  }
}
