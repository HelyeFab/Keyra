import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Keyra/features/dictionary/data/services/jisho_service.dart';
import 'package:Keyra/core/utils/logger.dart';

// Events
/// Events for the Jisho meanings bloc.
abstract class JishoMeaningsEvent extends Equatable {
  const JishoMeaningsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load Jisho meanings for a given word.
class LoadJishoMeanings extends JishoMeaningsEvent {
  final String word;

  const LoadJishoMeanings(this.word);

  @override
  List<Object?> get props => [word];
}

// States
/// States for the Jisho meanings bloc.
abstract class JishoMeaningsState extends Equatable {
  const JishoMeaningsState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the Jisho meanings bloc.
class JishoMeaningsInitial extends JishoMeaningsState {}

/// State when Jisho meanings are being loaded.
class JishoMeaningsLoading extends JishoMeaningsState {}

/// State when Jisho meanings have been loaded successfully.
class JishoMeaningsLoaded extends JishoMeaningsState {
  final Map<String, dynamic> meanings;

  const JishoMeaningsLoaded(this.meanings);

  @override
  List<Object?> get props => [meanings];
}

/// State when an error occurs while loading Jisho meanings.
class JishoMeaningsError extends JishoMeaningsState {
  final String message;

  const JishoMeaningsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
/// Bloc for managing Jisho meanings.
class JishoMeaningsBloc extends Bloc<JishoMeaningsEvent, JishoMeaningsState> {
  final JishoService _jishoService;

  JishoMeaningsBloc({JishoService? jishoService})
      : _jishoService = jishoService ?? JishoService(),
        super(JishoMeaningsInitial()) {
    on<LoadJishoMeanings>(_onLoadJishoMeanings);
  }

  /// Handles the LoadJishoMeanings event.
  Future<void> _onLoadJishoMeanings(
    LoadJishoMeanings event,
    Emitter<JishoMeaningsState> emit,
  ) async {
    try {
      emit(JishoMeaningsLoading());

      // Initialize service if needed
      if (!_jishoService.isInitialized) {
        try {
          await _jishoService.initialize();
        } catch (e) {
          Logger.error('Failed to initialize Jisho service', error: e);
          emit(JishoMeaningsError('Failed to initialize Jisho service: $e'));
          return;
        }
      }

      final meanings = await _jishoService.getJishoData(event.word);
      
      if (meanings != null) {
        emit(JishoMeaningsLoaded(meanings));
      } else {
        emit(const JishoMeaningsError('No Jisho meanings found'));
      }
    } catch (e) {
      Logger.error('Error loading Jisho meanings', error: e);
      emit(JishoMeaningsError(e.toString()));
    }
  }

  @override
  /// Closes the Jisho service when the bloc is closed.
  Future<void> close() async {
    await _jishoService.close();
    return super.close();
  }
}
