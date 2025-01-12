import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../../dashboard/data/repositories/user_stats_repository.dart';
import '../../../subscription/application/subscription_service.dart';
import 'package:flutter/services.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserStatsRepository _userStatsRepository;
  final SubscriptionService _subscriptionService;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserStatsRepository? userStatsRepository,
    required SubscriptionService subscriptionService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _userStatsRepository = userStatsRepository ?? UserStatsRepository(),
        _subscriptionService = subscriptionService;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      print('Starting Google Sign In...');
      GoogleSignInAccount? googleUser;
      try {
        // Try to get the current signed-in user first
        googleUser = await _googleSignIn.signInSilently();
        
        // If no current user, trigger the sign-in flow
        googleUser ??= await _googleSignIn.signIn();
      } catch (e) {
        // If we get the PigeonUserDetails error but have a valid user, continue
        if (!e.toString().contains('PigeonUserDetails') || googleUser == null) {
          rethrow;
        }
        print('Continuing despite PigeonUserDetails warning');
      }
      
      if (googleUser == null) {
        print('Sign in aborted by user');
        throw Exception('Sign in aborted by user');
      }

      print('Getting Google Auth credentials for user: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        print('Error: No access token received from Google');
        throw Exception('No access token received from Google');
      }

      print('Creating Firebase credential with tokens...');
      print('Access Token available: ${googleAuth.accessToken != null}');
      print('ID Token available: ${googleAuth.idToken != null}');
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in to Firebase...');
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      print('Successfully signed in with Google. UID: ${userCredential.user?.uid}');
      
      // Initialize user stats after successful sign in
      await _userStatsRepository.getUserStats();

      // Create subscription for new Google sign-in users
      if (userCredential.additionalUserInfo?.isNewUser == true && userCredential.user != null) {
        await _subscriptionService.createSubscriptionForUser(userCredential.user!);
      }
      
      return userCredential;
    } catch (e, stackTrace) {
      print('Error during Google Sign In: $e');
      print('Stack trace: $stackTrace');
      print('Detailed error info: ${e.runtimeType}');
      if (e is PlatformException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        print('Error details: ${e.details}');
      }
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Initialize user stats after successful sign in
      await _userStatsRepository.getUserStats();
      
      return userCredential;
    } catch (e) {
      throw Exception('Failed to sign in with email and password: $e');
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile with name
      await userCredential.user?.updateDisplayName(name);
      
      // Initialize user stats for new user
      await _userStatsRepository.getUserStats();

      // Create subscription for new user
      if (userCredential.user != null) {
        await _subscriptionService.createSubscriptionForUser(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }
}
