import 'dart:async';
import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthState> {
  final FirebaseAuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({
    required FirebaseAuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState.initial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<EmailSignUpRequested>(_onEmailSignUpRequested);
    on<StartAuthListening>(_onStartAuthListening);
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
  }

  void _onStartAuthListening(
    StartAuthListening event,
    Emitter<AuthState> emit,
  ) {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthBlocEvent.authStateChanged(user)),
    );
  }

  void _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      Logger.log('Starting Google Sign In process in AuthBloc...');
      final userCredential = await _authRepository.signInWithGoogle();
      Logger.log('Google Sign In successful in AuthBloc. User ID: ${userCredential.user?.uid}');
      emit(AuthState.authenticated(userCredential.user!.uid));
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to sign in with Google',
        error: e,
        stackTrace: stackTrace,
        throwError: true
      );
      
      String errorMessage;
      if (e.toString().contains('PigeonUserDetails')) {
        errorMessage = 'Authentication error. Please try signing out and in again';
      } else if (e.toString().contains('PlatformException')) {
        errorMessage = 'Google Sign In was cancelled or failed';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error occurred. Please check your connection';
      } else if (e.toString().contains('credential')) {
        errorMessage = 'Invalid credentials. Please try again';
      } else {
        errorMessage = 'Failed to sign in with Google: ${e.toString()}';
      }
      
      emit(AuthState.error(errorMessage));
    }
  }

  void _onEmailSignUpRequested(
    EmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      final userCredential = await _authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthState.authenticated(userCredential.user!.uid));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.authenticated(userCredential.user!.uid));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      final user = event.user as User;
      emit(AuthState.authenticated(user.uid));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.sendPasswordResetEmail(email: event.email);
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      Logger.log('Starting Apple Sign In process in AuthBloc...');
      // This will be implemented later when Firebase config is ready
      // final userCredential = await _authRepository.signInWithApple();
      // Logger.log('Apple Sign In successful in AuthBloc. User ID: ${userCredential.user?.uid}');
      // emit(AuthState.authenticated(userCredential.user!.uid));
      emit(const AuthState.error('Apple Sign In will be available soon'));
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to sign in with Apple',
        error: e,
        stackTrace: stackTrace,
        throwError: true
      );
      
      String errorMessage;
      if (e.toString().contains('canceled')) {
        errorMessage = 'Apple Sign In was cancelled';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error occurred. Please check your connection';
      } else if (e.toString().contains('credential')) {
        errorMessage = 'Invalid credentials. Please try again';
      } else {
        errorMessage = 'Failed to sign in with Apple: ${e.toString()}';
      }
      
      emit(AuthState.error(errorMessage));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
