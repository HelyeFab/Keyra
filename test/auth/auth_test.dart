import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/auth/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  group('Authentication Tests', () {
    test('signIn - successful login', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
      
      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Act
      final result = await authService.signIn(email, password);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
    });

    test('signIn - failed login', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrongpassword';
      
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act
      final result = await authService.signIn(email, password);

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold(
        (failure) => failure.code,
        (_) => null,
      ), equals('wrong-password'));
    });

    test('signUp - successful registration', () async {
      // Arrange
      const email = 'newuser@example.com';
      const password = 'newpassword123';
      
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
      
      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Act
      final result = await authService.signUp(email, password);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
    });

    test('signUp - email already in use', () async {
      // Arrange
      const email = 'existing@example.com';
      const password = 'password123';
      
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act
      final result = await authService.signUp(email, password);

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold(
        (failure) => failure.code,
        (_) => null,
      ), equals('email-already-in-use'));
    });

    test('signOut - successful', () async {
      // Arrange
      when(() => mockFirebaseAuth.signOut())
          .thenAnswer((_) async => {});

      // Act
      final result = await authService.signOut();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('resetPassword - successful', () async {
      // Arrange
      const email = 'test@example.com';
      
      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async => {});

      // Act
      final result = await authService.resetPassword(email);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .called(1);
    });

    test('getCurrentUser - returns current user', () async {
      // Arrange
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@example.com');

      // Act
      final user = authService.currentUser;

      // Assert
      expect(user, equals(mockUser));
      expect(user?.email, equals('test@example.com'));
    });

    test('authStateChanges - emits auth state changes', () async {
      // Arrange
      final authStates = Stream.fromIterable([null, mockUser]);
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => authStates);

      // Act & Assert
      expect(
        authService.authStateChanges(),
        emitsInOrder([null, mockUser]),
      );
    });
  });
}
