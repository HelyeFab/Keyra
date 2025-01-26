import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
}
