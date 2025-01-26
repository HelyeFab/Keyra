import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/utils/logger.dart';
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
      Logger.log('Starting Google Sign In...');
      GoogleSignInAccount? googleUser;
      try {
        // Try to get the current signed-in user first
        googleUser = await _googleSignIn.signInSilently();
        
        // If no current user, trigger the sign-in flow
        googleUser ??= await _googleSignIn.signIn();
      } catch (e) {
        // If we get the PigeonUserDetails error, verify we have both a valid Google user and Firebase user
        if (e.toString().contains('PigeonUserDetails') && googleUser != null) {
          // Verify Firebase user exists
          final currentUser = _firebaseAuth.currentUser;
          if (currentUser != null && currentUser.email == googleUser.email) {
            Logger.log('Continuing with existing Firebase user despite PigeonUserDetails warning');
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }
      
      if (googleUser == null) {
        Logger.log('Sign in aborted by user');
        throw Exception('Sign in aborted by user');
      }

      Logger.log('Getting Google Auth credentials for user: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        Logger.error('No access token received from Google', throwError: true);
        throw Exception('No access token received from Google');
      }

      Logger.log('Creating Firebase credential with tokens...');
      Logger.log('Access Token available: ${googleAuth.accessToken != null}');
      Logger.log('ID Token available: ${googleAuth.idToken != null}');
      
      // First check if we're already signed in with the correct email
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser?.email == googleUser.email) {
        Logger.log('Already signed in with correct email');
        // Re-authenticate to refresh tokens
        try {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final result = await currentUser!.reauthenticateWithCredential(credential);
          Logger.log('Successfully reauthenticated existing user');
          return result;
        } catch (e) {
          Logger.log('Reauthentication failed, but continuing with existing user');
          // Even if reauthentication fails, we can continue if the user is valid
          final email = currentUser?.email;
          if (email != null && email == googleUser.email) {
            // Force a user reload to ensure we have fresh data
            await currentUser?.reload();
            // Try to get a fresh instance of the user
            final freshUser = _firebaseAuth.currentUser;
            if (freshUser != null) {
              // Create a new credential using the Google provider
              final newCredential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              return await freshUser.linkWithCredential(newCredential);
            }
          }
        }
      }

      // If not already signed in or email doesn't match, sign in with new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Logger.log('Signing in to Firebase...');
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      Logger.log('Successfully signed in with Google. UID: ${userCredential.user?.uid}');
      
      // Initialize user stats after successful sign in
      await _userStatsRepository.getUserStats();

      // Create subscription for new Google sign-in users
      if (userCredential.additionalUserInfo?.isNewUser == true && userCredential.user != null) {
        await _subscriptionService.createSubscriptionForUser(userCredential.user!);
      }
      
      return userCredential;
    } catch (e, stackTrace) {
      Logger.error('Failed to sign in with Google', error: e, stackTrace: stackTrace);
      if (e is PlatformException) {
        Logger.error('Platform exception during sign in', error: e, stackTrace: stackTrace);
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
