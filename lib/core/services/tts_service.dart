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

  Stream<bool> get audioPlayerState => _audioPlayerStateController.stream;

  Future<void> init() async {
    try {
      _audioPlayer = AudioPlayer();
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

      _currentLanguage = language;
      _onComplete = onComplete;

      final languageCode = _getLanguageCode(language);
      Logger.log('TTS: Attempting to speak text in ${language.displayName} ($languageCode): ${text.substring(0, min(50, text.length))}...');

      // Get temporary directory to store audio file
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3';
      _currentAudioFile = File(tempPath);

      // Build Google TTS API URL
      // Google TTS has a character limit, so split long text into chunks
      const maxChunkLength = 200;
      final chunks = _splitTextIntoChunks(text, maxChunkLength);
      
      for (final chunk in chunks) {
        final url = Uri.parse(
          'https://translate.google.com/translate_tts'
          '?ie=UTF-8'
          '&q=${Uri.encodeComponent(chunk)}'
          '&tl=$languageCode'
          '&client=tw-ob'
          '&ttsspeed=1'
        ).toString();

        // Download audio file
        final response = await HttpClient().getUrl(Uri.parse(url));
        final audioData = await response.close();
        await _currentAudioFile!.writeAsBytes(await audioData.expand((x) => x).toList());

        // Play the audio file and wait for completion
        await _audioPlayer!.play(DeviceFileSource(_currentAudioFile!.path));
        _audioPlayerStateController.add(true);

        // Wait for this chunk to complete before proceeding
        await _audioPlayer!.onPlayerComplete.first;
      }

      // All chunks completed
      _audioPlayerStateController.add(false);
      _cleanupAudioFile();
      _onComplete?.call();
      Logger.log('TTS: Completed playback in ${language.displayName}');

    } catch (e) {
      Logger.error('TTS Speak Error', error: e);
      _cleanupAudioFile();
      _onComplete?.call();
      _audioPlayerStateController.add(false);
    }
  }

  Future<void> _cleanupAudioFile() async {
    try {
      if (_currentAudioFile != null && await _currentAudioFile!.exists()) {
        await _currentAudioFile!.delete();
        Logger.log('TTS: Cleaned up audio file');
      }
    } catch (e) {
      Logger.error('TTS: Cleanup error', error: e);
    }
  }

  Future<void> pause() async {
    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.pause();
        _audioPlayerStateController.add(false);
        Logger.log('TTS: Paused playback in ${_currentLanguage?.displayName ?? "unknown language"}');
      }
    } catch (e) {
      Logger.error('TTS Pause Error', error: e);
    }
  }

  Future<void> resume() async {
    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.resume();
        _audioPlayerStateController.add(true);
        Logger.log('TTS: Resumed playback in ${_currentLanguage?.displayName ?? "unknown language"}');
      }
    } catch (e) {
      Logger.error('TTS Resume Error', error: e);
    }
  }

  Future<void> stop() async {
    try {
      final previousLanguage = _currentLanguage?.displayName;
      await _audioPlayer?.stop();
      await _cleanupAudioFile();
      _currentAudioFile = null;
      _currentLanguage = null;
      _onComplete = null;
      _audioPlayerStateController.add(false);
      Logger.log('TTS: Stopped playback${previousLanguage != null ? " in $previousLanguage" : ""} and reset state');
    } catch (e) {
      Logger.error('TTS Stop Error', error: e);
      // Ensure a new player is created even if there's an error
      _audioPlayer = AudioPlayer();
    }
  }

  List<String> _splitTextIntoChunks(String text, int maxLength) {
    final List<String> chunks = [];
    final sentences = text.split(RegExp(r'[.!?。！？]')); // Split by sentence endings
    
    String currentChunk = '';
    
    for (var sentence in sentences) {
      sentence = sentence.trim();
      if (sentence.isEmpty) continue;
      
      // Add period back to sentence
      sentence = '$sentence.';
      
      if (currentChunk.length + sentence.length <= maxLength) {
        currentChunk += sentence;
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk);
        }
        // If single sentence is longer than maxLength, split it into words
        if (sentence.length > maxLength) {
          final words = sentence.split(' ');
          currentChunk = '';
          for (var word in words) {
            if (currentChunk.length + word.length + 1 <= maxLength) {
              currentChunk += '${currentChunk.isEmpty ? '' : ' '}$word';
            } else {
              if (currentChunk.isNotEmpty) {
                chunks.add(currentChunk);
              }
              currentChunk = word;
            }
          }
        } else {
          currentChunk = sentence;
        }
      }
    }
    
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }
    
    return chunks;
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'ja':
        return 'ja-JP';
      case 'fr':
        return 'fr-FR';
      case 'de':
        return 'de-DE';
      case 'it':
        return 'it-IT';
      case 'es':
        return 'es-ES';
      default:
        return 'en-US';
    }
  }
}
