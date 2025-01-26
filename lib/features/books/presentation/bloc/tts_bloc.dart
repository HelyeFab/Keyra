import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:equatable/equatable.dart';
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

class TTSSpeedChanged extends TTSEvent {
  final double speedFactor;

  const TTSSpeedChanged(this.speedFactor);

  @override
  List<Object?> get props => [speedFactor];
}

// States
abstract class TTSState extends Equatable {
  final double speedFactor;
  
  const TTSState({required this.speedFactor});

  @override
  List<Object> get props => [speedFactor];
}

class TTSInitial extends TTSState {
  const TTSInitial() : super(speedFactor: 1.0);
}

class TTSPlaying extends TTSState {
  final String text;
  final BookLanguage language;

  const TTSPlaying({
    required this.text,
    required this.language,
    required double speedFactor,
  }) : super(speedFactor: speedFactor);

  @override
  List<Object> get props => [text, language, speedFactor];
}

class TTSPausedState extends TTSState {
  final String text;
  final BookLanguage language;

  const TTSPausedState({
    required this.text,
    required this.language,
    required double speedFactor,
  }) : super(speedFactor: speedFactor);

  @override
  List<Object> get props => [text, language, speedFactor];
}

class TTSStoppedState extends TTSState {
  const TTSStoppedState({required double speedFactor}) : super(speedFactor: speedFactor);
}

// Bloc
class TTSBloc extends Bloc<TTSEvent, TTSState> {
  final TTSService _ttsService;

  TTSBloc({TTSService? ttsService}) : 
    _ttsService = ttsService ?? TTSService(),
    super(const TTSInitial()) {
    _init();
    on<TTSStarted>(_onStarted);
    on<TTSPauseRequested>(_onPauseRequested);
    on<TTSResumeRequested>(_onResumeRequested);
    on<TTSStopRequested>(_onStopRequested);
    on<TTSCompleted>(_onCompleted);
    on<TTSSpeedChanged>(_onSpeedChanged);

    // Listen to audio player state changes
    _ttsService.audioPlayerState.listen((isPlaying) {
      if (isPlaying) {
        if (state is! TTSPlaying) {
          if (state is TTSPausedState) {
            final pausedState = state as TTSPausedState;
            emit(TTSPlaying(
              text: pausedState.text,
              language: pausedState.language,
              speedFactor: state.speedFactor,
            ));
          } else if (_currentText != null && _currentLanguage != null) {
            emit(TTSPlaying(
              text: _currentText!,
              language: _currentLanguage!,
              speedFactor: state.speedFactor,
            ));
          }
        }
      } else if (!isPlaying && state is TTSPlaying) {
        emit(TTSStoppedState(speedFactor: state.speedFactor));
      }
    });
    
    Logger.log('TTSBloc: Initialized');
  }

  Future<void> _init() async {
    await _ttsService.init();
    Logger.log('TTSBloc: TTS service initialized');
  }

  String? _currentText;
  BookLanguage? _currentLanguage;

  Future<void> _onStarted(TTSStarted event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSStarted event with text: ${event.text.substring(0, min(50, event.text.length))}...');
    _currentText = event.text;
    _currentLanguage = event.language;
    final currentSpeedFactor = state is TTSInitial ? 1.0 : state.speedFactor;
    emit(TTSPlaying(
      text: event.text,
      language: event.language,
      speedFactor: currentSpeedFactor,
    ));
    await _ttsService.speak(event.text, event.language, onComplete: () {
      add(TTSCompleted());
    });
    Logger.log('TTSBloc: Started TTS playback');
  }

  Future<void> _onCompleted(TTSCompleted event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSCompleted event');
    emit(TTSStoppedState(speedFactor: state.speedFactor));
    Logger.log('TTSBloc: Emitted TTSStoppedState state');
  }

  Future<void> _onPauseRequested(TTSPauseRequested event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSPauseRequested event');
    if (state is TTSPlaying) {
      final currentState = state as TTSPlaying;
      await _ttsService.pause();
      emit(TTSPausedState(
        text: currentState.text,
        language: currentState.language,
        speedFactor: currentState.speedFactor,
      ));
      Logger.log('TTSBloc: Emitted TTSPausedState state');
    }
  }

  Future<void> _onResumeRequested(TTSResumeRequested event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSResumeRequested event');
    if (state is TTSPausedState) {
      final currentState = state as TTSPausedState;
      await _ttsService.resume();
      emit(TTSPlaying(
        text: currentState.text,
        language: currentState.language,
        speedFactor: currentState.speedFactor,
      ));
      Logger.log('TTSBloc: Emitted TTSPlaying state');
    }
  }

  Future<void> _onStopRequested(TTSStopRequested event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSStopRequested event');
    await _ttsService.stop();
    final currentSpeedFactor = state is TTSInitial ? 1.0 : state.speedFactor;
    emit(TTSStoppedState(speedFactor: currentSpeedFactor));
    Logger.log('TTSBloc: Emitted TTSStoppedState state');
  }

  Future<void> _onSpeedChanged(TTSSpeedChanged event, Emitter<TTSState> emit) async {
    Logger.log('TTSBloc: Received TTSSpeedChanged event with speed: ${event.speedFactor}');
    _ttsService.setSpeedFactor(event.speedFactor);
    
    if (state is TTSPlaying) {
      final currentState = state as TTSPlaying;
      emit(TTSPlaying(
        text: currentState.text,
        language: currentState.language,
        speedFactor: event.speedFactor,
      ));
    } else if (state is TTSPausedState) {
      final currentState = state as TTSPausedState;
      emit(TTSPausedState(
        text: currentState.text,
        language: currentState.language,
        speedFactor: event.speedFactor,
      ));
    } else {
      emit(TTSStoppedState(speedFactor: event.speedFactor));
    }
    Logger.log('TTSBloc: Updated speed factor');
  }

  @override
  Future<void> close() async {
    Logger.log('TTSBloc: Closing');
    await _ttsService.stop();
    return super.close();
  }
}
