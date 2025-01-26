import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthFailure {
  final String code;
  final String message;

  AuthFailure({required this.code, required this.message});
}

class AuthService {
  final FirebaseAuth firebaseAuth;

  AuthService({required this.firebaseAuth});

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();

  Future<Either<AuthFailure, UserCredential>> signIn(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        code: e.code,
        message: e.message ?? 'Authentication failed',
      ));
    }
  }

  Future<Either<AuthFailure, UserCredential>> signUp(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        code: e.code,
        message: e.message ?? 'Registration failed',
      ));
    }
  }

  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        code: e.code,
        message: e.message ?? 'Sign out failed',
      ));
    }
  }

  Future<Either<AuthFailure, void>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        code: e.code,
        message: e.message ?? 'Password reset failed',
      ));
    }
  }
}
