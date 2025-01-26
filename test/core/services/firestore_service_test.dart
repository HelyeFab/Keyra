import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/services/firestore_service.dart';


class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock 
    implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock 
    implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock 
    implements QuerySnapshot<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock 
    implements DocumentSnapshot<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}
class MockQueryDocumentSnapshot extends Mock 
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late FirestoreService firestoreService;
  late MockDocumentReference mockDocRef;
  late MockCollectionReference mockCollectionRef;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockDocRef = MockDocumentReference();
    mockCollectionRef = MockCollectionReference();
    firestoreService = FirestoreService(
      firestore: mockFirestore,
      auth: mockAuth
    );

    // Register fallback values
    registerFallbackValue(MockDocumentReference());
    registerFallbackValue({'lastUpdated': FieldValue.serverTimestamp()});

    // Set up basic auth mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-user-id');

    // Set up basic collection/document hierarchy
    when(() => mockFirestore.collection(any())).thenReturn(mockCollectionRef);
    when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.collection(any())).thenReturn(mockCollectionRef);
  });

  group('FirestoreService', () {
    group('getSavedWordsWithDetails', () {
      test('returns empty stream when user not authenticated', () {
        when(() => mockAuth.currentUser).thenReturn(null);

        expect(firestoreService.getSavedWordsWithDetails(), emits([]));
      });

      test('transforms snapshot data correctly', () {
        final mockCollection = MockCollectionReference();
        final mockDoc = MockDocumentReference();
        final mockSnapshot = MockQuerySnapshot();
        final mockDocSnapshot = MockQueryDocumentSnapshot();

        // Setup document data
        when(() => mockDocSnapshot.id).thenReturn('word-1');
        when(() => mockDocSnapshot.data()).thenReturn({
          'word': 'test',
          'translation': 'prueba',
          'language': 'es',
        });

        // Setup collection hierarchy
        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('test-user-id'))
            .thenReturn(mockDoc);
        when(() => mockDoc.collection('saved_words'))
            .thenReturn(mockCollection);
        when(() => mockCollection.snapshots())
            .thenAnswer((_) => Stream.value(mockSnapshot));
        when(() => mockSnapshot.docs).thenReturn([mockDocSnapshot]);

        // Test stream output
        expect(
          firestoreService.getSavedWordsWithDetails(),
          emits([
            {
              'id': 'word-1',
              'word': 'test',
              'translation': 'prueba',
              'language': 'es',
            }
          ]),
        );
      });

      test('handles empty snapshots', () {
        final mockCollection = MockCollectionReference();
        final mockDoc = MockDocumentReference();
        final mockSnapshot = MockQuerySnapshot();

        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('test-user-id'))
            .thenReturn(mockDoc);
        when(() => mockDoc.collection('saved_words'))
            .thenReturn(mockCollection);
        when(() => mockCollection.snapshots())
            .thenAnswer((_) => Stream.value(mockSnapshot));
        when(() => mockSnapshot.docs).thenReturn([]);

        expect(firestoreService.getSavedWordsWithDetails(), emits([]));
      });
    });

    group('deleteSavedWord', () {
      test('throws exception when user not authenticated', () {
        when(() => mockAuth.currentUser).thenReturn(null);

        expect(
          () => firestoreService.deleteSavedWord('word-1'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('User not authenticated'),
          )),
        );
      });

      test('performs batch delete operation correctly', () async {
        final mockBatch = MockWriteBatch();
        final mockCollection = MockCollectionReference();
        final mockDoc = MockDocumentReference();
        final mockSnapshot = MockQuerySnapshot();

        // Setup collection hierarchy
        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('test-user-id'))
            .thenReturn(mockDoc);
        when(() => mockDoc.collection('saved_words'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('word-1'))
            .thenReturn(mockDoc);
        
        // Setup batch operations
        when(() => mockFirestore.batch()).thenReturn(mockBatch);
        when(() => mockBatch.delete(any())).thenReturn(null);
        when(() => mockBatch.update(any(), any())).thenReturn(null);
        when(() => mockBatch.commit()).thenAnswer((_) async => []);

        // Setup snapshot for count
        when(() => mockCollection.get())
            .thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.docs).thenReturn(List.generate(5, (i) => MockQueryDocumentSnapshot()));

        // Execute delete
        await firestoreService.deleteSavedWord('word-1');

        // Verify batch operations
        verify(() => mockBatch.delete(any())).called(1);
        verify(() => mockBatch.update(any(), any())).called(1);
        verify(() => mockBatch.commit()).called(1);
      });

      test('handles batch operation errors gracefully', () async {
        final mockBatch = MockWriteBatch();
        final mockCollection = MockCollectionReference();
        final mockDoc = MockDocumentReference();
        final mockSnapshot = MockQuerySnapshot();

        // Setup collection hierarchy
        when(() => mockFirestore.collection('users'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('test-user-id'))
            .thenReturn(mockDoc);
        when(() => mockDoc.collection('saved_words'))
            .thenReturn(mockCollection);
        when(() => mockCollection.doc('word-1'))
            .thenReturn(mockDoc);
        when(() => mockCollection.get())
            .thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.docs).thenReturn([]);
        
        // Setup batch to throw error
        when(() => mockFirestore.batch()).thenReturn(mockBatch);
        when(() => mockBatch.delete(any())).thenReturn(null);
        when(() => mockBatch.update(any(), any())).thenReturn(null);
        when(() => mockBatch.commit())
            .thenThrow(FirebaseException(plugin: 'firestore', message: 'Batch failed'));

        // Verify error is propagated
        await expectLater(
          firestoreService.deleteSavedWord('word-1'),
          throwsA(isA<FirebaseException>()),
        );
      });
    });
  });
}
