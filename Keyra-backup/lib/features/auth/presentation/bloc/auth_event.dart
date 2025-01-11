part of 'auth_bloc.dart';

@freezed
class AuthBlocEvent with _$AuthBlocEvent {
  const factory AuthBlocEvent.googleSignInRequested() = GoogleSignInRequested;
  const factory AuthBlocEvent.emailSignUpRequested({
    required String email,
    required String password,
    required String name,
  }) = EmailSignUpRequested;
  const factory AuthBlocEvent.emailSignInRequested({
    required String email,
    required String password,
  }) = EmailSignInRequested;
  const factory AuthBlocEvent.signOutRequested() = SignOutRequested;
  const factory AuthBlocEvent.authStateChanged(dynamic user) = AuthStateChanged;
  const factory AuthBlocEvent.appleSignInRequested() = AppleSignInRequested;
  const factory AuthBlocEvent.startAuthListening() = StartAuthListening;
}
