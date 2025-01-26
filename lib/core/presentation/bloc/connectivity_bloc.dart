import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../services/connectivity_service.dart';

// Events
abstract class ConnectivityEvent {}

class ConnectivityStartMonitoring extends ConnectivityEvent {}
class ConnectivityStatusChanged extends ConnectivityEvent {
  final bool isConnected;
  ConnectivityStatusChanged(this.isConnected);
}

// State
class ConnectivityState {
  final bool isConnected;
  final bool hasCheckedInitially;

  ConnectivityState({
    required this.isConnected,
    required this.hasCheckedInitially,
  });

  ConnectivityState copyWith({
    bool? isConnected,
    bool? hasCheckedInitially,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      hasCheckedInitially: hasCheckedInitially ?? this.hasCheckedInitially,
    );
  }
}

// Bloc
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityBloc()
      : _connectivityService = ConnectivityService(),
        super(ConnectivityState(isConnected: true, hasCheckedInitially: false)) {
    on<ConnectivityStartMonitoring>(_onStartMonitoring);
    on<ConnectivityStatusChanged>(_onStatusChanged);

    // Start monitoring immediately
    add(ConnectivityStartMonitoring());
  }

  Future<void> _onStartMonitoring(
    ConnectivityStartMonitoring event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Check initial connectivity
    final isConnected = await _connectivityService.hasConnection();
    emit(state.copyWith(
      isConnected: isConnected,
      hasCheckedInitially: true,
    ));

    // Start listening to connectivity changes
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {
      add(ConnectivityStatusChanged(result != ConnectivityResult.none));
    });
  }

  void _onStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(state.copyWith(isConnected: event.isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
