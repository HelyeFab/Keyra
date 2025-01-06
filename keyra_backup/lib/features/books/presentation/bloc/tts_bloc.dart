import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:Keyra/core/services/tts_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

// Events
abstract class TTSEvent extends Equatable {
  const TTSEvent();

  @override
  List<Object?> get props => [];
}

class TTSCompleted extends TTSEvent {}

class TTSStarted extends TTSEvent {
  final String text;
  final BookLanguage language;

  const TTSStarted({required this.text, required this.language});

  @override
  List<Object?> get props => [text, language];
}

class TTSPauseRequested extends TTSEvent {}

class TTSResumeRequested extends TTSEvent {}

class TTSStopRequested extends TTSEvent {}

// States
abstract class TTSState extends Equatable {
  const TTSState();

  @override
  List<Object?> get props => [];
}

class TTSInitial extends TTSState {}

class TTSPlaying extends TTSState {
  final String text;
  final BookLanguage language;

  const TTSPlaying({required this.text, required this.language});

  @override
  List<Object?> get props => [text, language];
}

class TTSPausedState extends TTSState {
  final String text;
  final BookLanguage language;

  const TTSPausedState({required this.text, required this.language});

  @override
  List<Object?> get props => [text, language];
}

class TTSStoppedState extends TTSState {}

// Bloc
class TTSBloc extends Bloc<TTSEvent, TTSState> {
  final TTSService _ttsService;

  TTSBloc({TTSService? ttsService}) : 
    _ttsService = ttsService ?? TTSService(),
    super(TTSInitial()) {
    _init();
    on<TTSStarted>(_onStarted);
    on<TTSPauseRequested>(_onPauseRequested);
    on<TTSResumeRequested>(_onResumeRequested);
    on<TTSStopRequested>(_onStopRequested);
    on<TTSCompleted>(_onCompleted);

    // Listen to audio player state changes
    _ttsService.audioPlayerState.listen((isPlaying) {
      if (isPlaying) {
        if (state is! TTSPlaying) {
          if (state is TTSPausedState) {
            final pausedState = state as TTSPausedState;
            emit(TTSPlaying(text: pausedState.text, language: pausedState.language));
          } else if (_currentText != null && _currentLanguage != null) {
            emit(TTSPlaying(text: _currentText!, language: _currentLanguage!));
          }
        }
      } else if (!isPlaying && state is TTSPlaying) {
        emit(TTSStoppedState());
      }
    });
    
    debugPrint('TTSBloc: Initialized');
  }

  Future<void> _init() async {
    await _ttsService.init();
    debugPrint('TTSBloc: TTS service initialized');
  }

  String? _currentText;
  BookLanguage? _currentLanguage;

  Future<void> _onStarted(TTSStarted event, Emitter<TTSState> emit) async {
    debugPrint('TTSBloc: Received TTSStarted event with text: ${event.text.substring(0, min(50, event.text.length))}...');
    _currentText = event.text;
    _currentLanguage = event.language;
    emit(TTSPlaying(text: event.text, language: event.language));
    await _ttsService.speak(event.text, event.language, onComplete: () {
      add(TTSCompleted());
    });
    debugPrint('TTSBloc: Started TTS playback');
  }

  Future<void> _onCompleted(TTSCompleted event, Emitter<TTSState> emit) async {
    debugPrint('TTSBloc: Received TTSCompleted event');
    emit(TTSStoppedState());
    debugPrint('TTSBloc: Emitted TTSStoppedState state');
  }

  Future<void> _onPauseRequested(TTSPauseRequested event, Emitter<TTSState> emit) async {
    debugPrint('TTSBloc: Received TTSPauseRequested event');
    if (state is TTSPlaying) {
      final currentState = state as TTSPlaying;
      await _ttsService.pause();
      emit(TTSPausedState(text: currentState.text, language: currentState.language));
      debugPrint('TTSBloc: Emitted TTSPausedState state');
    }
  }

  Future<void> _onResumeRequested(TTSResumeRequested event, Emitter<TTSState> emit) async {
    debugPrint('TTSBloc: Received TTSResumeRequested event');
    if (state is TTSPausedState) {
      final currentState = state as TTSPausedState;
      await _ttsService.resume();
      emit(TTSPlaying(text: currentState.text, language: currentState.language));
      debugPrint('TTSBloc: Emitted TTSPlaying state');
    }
  }

  Future<void> _onStopRequested(TTSStopRequested event, Emitter<TTSState> emit) async {
    debugPrint('TTSBloc: Received TTSStopRequested event');
    await _ttsService.stop();
    emit(TTSStoppedState());
    debugPrint('TTSBloc: Emitted TTSStoppedState state');
  }

  @override
  Future<void> close() async {
    debugPrint('TTSBloc: Closing');
    await _ttsService.stop();
    return super.close();
  }
}
