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
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 1);
  static const _sentenceTimeout = Duration(seconds: 15);

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

      // Stop any existing playback without triggering completion
      _isPlaying = false;
      await _audioPlayer?.stop();
      await _cleanupAudioFile();
      _audioPlayerStateController.add(false);

      // Set up new playback
      _currentLanguage = language;
      _currentText = text;
      _onComplete = onComplete;
      _isPlaying = true;
      _audioPlayerStateController.add(true);  // Set playing state immediately
      Logger.log('TTS: Starting new playback');

      final languageCode = _getLanguageCode(language);
      Logger.log('TTS: Attempting to speak text in ${language.displayName} ($languageCode) at speed ${_speedFactor}x: ${text.substring(0, min(50, text.length))}...');

      try {
        // Split text into sentences based on language
        final List<String> sentences;
        if (language.code == 'ja') {
          // Handle Japanese text with more punctuation marks and keep them in the output
          final pattern = RegExp(r'[^。．！？\n]+[。．！？]?');
          sentences = pattern.allMatches(text)
              .map((m) => m.group(0) ?? '')
              .where((s) => s.trim().isNotEmpty)
              .toList();
          Logger.log('TTS: Split Japanese text into ${sentences.length} sentences using enhanced pattern');
        } else {
          // For other languages, split on sentence endings and filter empty entries
          final pattern = RegExp(r'[^.!?\n]+[.!?]?');
          sentences = pattern.allMatches(text)
              .map((m) => m.group(0) ?? '')
              .where((s) => s.trim().isNotEmpty)
              .toList();
          Logger.log('TTS: Split text into ${sentences.length} sentences');
        }

        final totalSentences = sentences.length;
        var completedSentences = 0;

        for (int i = 0; i < sentences.length; i++) {
          if (!_isPlaying) {
            Logger.log('TTS: Playback stopped early');
            _audioPlayerStateController.add(false);
            return;
          }

          final sentence = sentences[i].trim();
          if (sentence.isEmpty) continue;

          Logger.log('TTS: Processing sentence ${i + 1}/$totalSentences: ${sentence.substring(0, min(30, sentence.length))}...');

          int retryCount = 0;
          bool success = false;

          while (!success && retryCount < _maxRetries && _isPlaying) {
            try {
              final url = Uri.parse(
                'https://translate.google.com/translate_tts'
                '?ie=UTF-8'
                '&q=${Uri.encodeComponent(sentence)}'
                '&tl=$languageCode'
                '&client=tw-ob'
                '&ttsspeed=1'
              ).toString();

              // Get temporary directory to store audio file
              final tempDir = await getTemporaryDirectory();
              final tempPath = '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3';
              _currentAudioFile = File(tempPath);

              // Download audio file with timeout
              final response = await HttpClient().getUrl(Uri.parse(url))
                  .timeout(const Duration(seconds: 10));
              final audioData = await response.close();
              await _currentAudioFile!.writeAsBytes(await audioData.expand((x) => x).toList());

              if (_isPlaying) {
                // Set up completion for this sentence
                final completer = Completer<void>();
                StreamSubscription? subscription;

                try {
                  // Set up completion listener before playing
                  subscription = _audioPlayer!.onPlayerComplete.listen((_) {
                    Logger.log('TTS: Sentence ${i + 1}/$totalSentences completed');
                    if (!completer.isCompleted) {
                      completer.complete();
                    }
                  });

                  // Play the sentence
                  await _audioPlayer!.play(DeviceFileSource(_currentAudioFile!.path));
                  await _audioPlayer!.setPlaybackRate(_speedFactor);

                  // Wait for sentence to complete with timeout
                  await completer.future.timeout(
                    _sentenceTimeout,
                    onTimeout: () {
                      Logger.log('TTS: Sentence completion timeout');
                      return;
                    },
                  );

                  success = true;
                  completedSentences++;

                  // Clean up audio file
                  await _cleanupAudioFile();

                  // If this was the last sentence, reset state and call completion
                  if (completedSentences == totalSentences) {
                    Logger.log('TTS: All sentences completed, resetting state');
                    _isPlaying = false;
                    await _audioPlayer?.stop();
                    _audioPlayerStateController.add(false);
                    if (_onComplete != null) {
                      Logger.log('TTS: Calling completion callback');
                      _onComplete!.call();
                    }
                    return;
                  } else {
                    // Add a small pause between sentences
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                } catch (e) {
                  Logger.error('TTS: Error during sentence playback', error: e);
                  success = false;
                } finally {
                  await subscription?.cancel();
                }
              }
            } catch (e) {
              Logger.error('TTS: Error processing sentence (attempt ${retryCount + 1}/$_maxRetries)', error: e);
              retryCount++;
              if (retryCount < _maxRetries) {
                await Future.delayed(_retryDelay);
              }
            }
          }

          if (!success) {
            Logger.error('TTS: Failed to process sentence after $_maxRetries attempts');
            continue;
          }
        }

        // Ensure we reset state if we somehow exit the loop without completing
        if (_isPlaying) {
          _isPlaying = false;
          await _audioPlayer?.stop();
          _audioPlayerStateController.add(false);
          if (_onComplete != null) {
            _onComplete!.call();
          }
        }
      } catch (e) {
        Logger.error('TTS Sentence Processing Error', error: e);
        rethrow;
      }
    } catch (e) {
      Logger.error('TTS Speak Error', error: e);
      // Clean up and reset state on error
      await _cleanupAudioFile();
      _isPlaying = false;
      _audioPlayerStateController.add(false);
      if (_onComplete != null) {
        Logger.log('TTS: Calling completion callback after error');
        _onComplete!.call();
      }
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
      await _audioPlayer!.setPlaybackRate(_speedFactor);
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
