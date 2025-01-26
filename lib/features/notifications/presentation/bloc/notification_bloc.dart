import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/notification_service.dart';

// Events
abstract class NotificationEvent {}

class RequestNotificationPermission extends NotificationEvent {}

class ScheduleDailyReminder extends NotificationEvent {
  final String title;
  final String body;
  final TimeOfDay time;

  ScheduleDailyReminder({
    required this.title,
    required this.body,
    required this.time,
  });
}

class CancelAllNotifications extends NotificationEvent {}

// States
abstract class NotificationState {
  final TimeOfDay? notificationTime;
  final bool isEnabled;
  
  NotificationState({
    this.notificationTime,
    this.isEnabled = false,
  });
}

class NotificationInitial extends NotificationState {
  NotificationInitial() : super();
}

class NotificationPermissionGranted extends NotificationState {
  NotificationPermissionGranted({TimeOfDay? notificationTime}) 
    : super(notificationTime: notificationTime, isEnabled: true);
}

class NotificationPermissionDenied extends NotificationState {
  NotificationPermissionDenied() : super();
}

class NotificationScheduled extends NotificationState {
  NotificationScheduled({required TimeOfDay notificationTime}) 
    : super(notificationTime: notificationTime, isEnabled: true);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message, {TimeOfDay? notificationTime, bool isEnabled = false}) 
    : super(notificationTime: notificationTime, isEnabled: isEnabled);
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc({
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(NotificationInitial()) {
    on<RequestNotificationPermission>(_onRequestPermission);
    on<ScheduleDailyReminder>(_onScheduleDailyReminder);
    on<CancelAllNotifications>(_onCancelAllNotifications);
  }

  Future<void> _onRequestPermission(
    RequestNotificationPermission event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.initialize();
      await _notificationService.requestPermissions();
      emit(NotificationPermissionGranted());
    } catch (e) {
      emit(NotificationError('Failed to request notification permissions: $e'));
    }
  }

  Future<void> _onScheduleDailyReminder(
    ScheduleDailyReminder event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.scheduleDailyReminder(
        title: event.title,
        body: event.body,
        time: event.time,
      );
      emit(NotificationScheduled(notificationTime: event.time));
    } catch (e) {
      // Preserve the current notification time and enabled state in case of error
      final currentState = state;
      emit(NotificationError(
        'Failed to schedule reminder: $e',
        notificationTime: currentState.notificationTime,
        isEnabled: currentState.isEnabled,
      ));
    }
  }

  Future<void> _onCancelAllNotifications(
    CancelAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.cancelAllNotifications();
      emit(NotificationInitial());
    } catch (e) {
      // Preserve the current notification time and enabled state in case of error
      final currentState = state;
      emit(NotificationError(
        'Failed to cancel notifications: $e',
        notificationTime: currentState.notificationTime,
        isEnabled: currentState.isEnabled,
      ));
    }
  }
}
