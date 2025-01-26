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
class MockQueryDocumentSnapshot extends Mock 
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late FirestoreService firestoreService;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;

  setUpAll(() {
    registerFallbackValue(MockDocumentReference());
    registerFallbackValue(MockCollectionReference());
    registerFallbackValue({'lastUpdated': FieldValue.serverTimestamp()});
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    // Setup auth mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-user-id');

    // Setup Firestore mocks
    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.collection(any())).thenReturn(mockCollection);

    firestoreService = FirestoreService(
      firestore: mockFirestore,
      auth: mockAuth
    );
  });

  group('Firestore Performance Tests', () {
    test('getSavedWordsWithDetails completes within performance threshold', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockQuerySnapshot();
      final mockDocs = List.generate(100, (i) {
        final doc = MockQueryDocumentSnapshot();
        when(() => doc.id).thenReturn('word-$i');
        when(() => doc.data()).thenReturn({
          'word': 'test-$i',
          'translation': 'prueba-$i',
          'language': 'es',
        });
        return doc;
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
      when(() => mockSnapshot.docs).thenReturn(mockDocs);

      // Measure performance
      final stopwatch = Stopwatch()..start();
      
      await firestoreService.getSavedWordsWithDetails()
          .first; // Get first emission
      
      stopwatch.stop();

      // Performance threshold: 100ms for processing 100 documents
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'Processing 100 documents should take less than 100ms');
    });

    test('batch operations complete within performance threshold', () async {
      final mockBatch = MockWriteBatch();
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockQuerySnapshot();
      final mockDocs = List.generate(100, (i) => MockQueryDocumentSnapshot());

      // Setup collection hierarchy
      when(() => mockFirestore.collection('users'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('test-user-id'))
          .thenReturn(mockDoc);
      when(() => mockDoc.collection('saved_words'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc(any()))
          .thenReturn(mockDoc);
      when(() => mockCollection.get())
          .thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn(mockDocs);
      
      // Setup batch operations
      when(() => mockFirestore.batch()).thenReturn(mockBatch);
      when(() => mockBatch.delete(any())).thenReturn(null);
      when(() => mockBatch.update(any(), any())).thenReturn(null);
      when(() => mockBatch.commit()).thenAnswer((_) async => []);

      // Measure performance
      final stopwatch = Stopwatch()..start();
      
      await firestoreService.deleteSavedWord('word-1');
      
      stopwatch.stop();

      // Performance threshold: 50ms for a batch operation
      expect(stopwatch.elapsedMilliseconds, lessThan(50),
          reason: 'Batch operation should complete within 50ms');
    });

    test('handles large data sets efficiently', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockQuerySnapshot();
      final mockDocs = List.generate(1000, (i) {
        final doc = MockQueryDocumentSnapshot();
        when(() => doc.id).thenReturn('word-$i');
        when(() => doc.data()).thenReturn({
          'word': 'test-$i',
          'translation': 'prueba-$i',
          'language': 'es',
          'additionalData': List.generate(10, (j) => 'data-$j').join(','),
        });
        return doc;
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
      when(() => mockSnapshot.docs).thenReturn(mockDocs);

      // Measure memory usage
      final stopwatch = Stopwatch()..start();
      final memory = <String, dynamic>{};
      
      await for (final words in firestoreService.getSavedWordsWithDetails()) {
        memory['words'] = words; // Store in memory to simulate real usage
        break; // Only need first emission
      }
      
      stopwatch.stop();

      // Performance thresholds
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
          reason: 'Processing 1000 documents should take less than 500ms');
      
      // Memory threshold (rough estimation)
      final estimatedMemoryUsage = memory['words'].toString().length;
      expect(estimatedMemoryUsage, lessThan(1000000),
          reason: 'Memory usage should be reasonable for 1000 documents');
    });
  });
}
