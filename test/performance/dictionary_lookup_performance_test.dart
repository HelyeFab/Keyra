import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/features/dictionary/services/dictionary_service.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryService dictionaryService;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockCollectionReference mockDictionaryCollection;
  late MockCollectionReference mockHistoryCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentReference mockHistoryDocRef;
  late MockDocumentSnapshot mockDoc;

  setUpAll(() {
    registerFallbackValue(MockDocumentReference());
    registerFallbackValue(MockCollectionReference());
    registerFallbackValue({'lastUpdated': FieldValue.serverTimestamp()});
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockDictionaryCollection = MockCollectionReference();
    mockHistoryCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockHistoryDocRef = MockDocumentReference();
    mockDoc = MockDocumentSnapshot();

    // Setup auth mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-user-id');

    // Setup basic document data
    when(() => mockDoc.exists).thenReturn(true);
    when(() => mockDoc.data()).thenReturn({
      'word': 'test',
      'translation': 'prueba',
      'language': 'es',
      'definitions': ['default definition'],
    });

    // Setup dictionary collection chain
    when(() => mockFirestore.collection('dictionary')).thenReturn(mockDictionaryCollection);
    when(() => mockDictionaryCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenAnswer((_) async => mockDoc);

    // Setup lookup history collection chain
    when(() => mockFirestore.collection('users')).thenReturn(mockHistoryCollection);
    when(() => mockHistoryCollection.doc('test-user-id')).thenReturn(mockHistoryDocRef);
    when(() => mockHistoryDocRef.collection('lookup_history')).thenReturn(mockHistoryCollection);
    when(() => mockHistoryCollection.doc(any())).thenReturn(mockHistoryDocRef);
    when(() => mockHistoryDocRef.set(any(), any())).thenAnswer((_) async {});

    dictionaryService = DictionaryService(
      firestore: mockFirestore,
      auth: mockAuth,
    );
  });

  group('Dictionary Lookup Performance Tests', () {
    test('single word lookup completes within threshold', () async {
      // Setup mock data
      final mockDoc = MockDocumentSnapshot();
      when(() => mockDoc.exists).thenReturn(true);
      when(() => mockDoc.data()).thenReturn({
        'word': 'test',
        'translation': 'prueba',
        'language': 'es',
        'definitions': ['a procedure for testing something'],
      });

      when(() => mockDocRef.get()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Simulate network delay
        return mockDoc;
      });

      final stopwatch = Stopwatch()..start();

      await dictionaryService.lookupWord('test', 'es');

      stopwatch.stop();

      // Performance threshold: 100ms for single word lookup
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'Single word lookup should complete within 100ms');
    });

    test('batch word lookup performs efficiently', () async {
      // Setup mock data for multiple words
      final words = List.generate(10, (i) => 'word$i');
      final mockDocs = words.map((word) {
        final doc = MockDocumentSnapshot();
        when(() => doc.exists).thenReturn(true);
        when(() => doc.data()).thenReturn({
          'word': word,
          'translation': 'translation$word',
          'language': 'es',
          'definitions': ['definition for $word'],
        });
        return doc;
      }).toList();

      // Setup document references for each word
      for (var i = 0; i < words.length; i++) {
        final docRef = MockDocumentReference();
        when(() => mockDictionaryCollection.doc(words[i])).thenReturn(docRef);
        when(() => docRef.get()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 5)); // Simulate network delay
          return mockDocs[i];
        });
      }

      final stopwatch = Stopwatch()..start();

      await Future.wait(
        words.map((word) => dictionaryService.lookupWord(word, 'es'))
      );

      stopwatch.stop();

      // Performance threshold: 500ms for batch lookup of 10 words
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
          reason: 'Batch word lookup should complete within 500ms');
    });

    test('caches lookups for improved performance', () async {
      // Setup mock data
      final mockDoc = MockDocumentSnapshot();
      when(() => mockDoc.exists).thenReturn(true);
      when(() => mockDoc.data()).thenReturn({
        'word': 'test',
        'translation': 'prueba',
        'language': 'es',
        'definitions': ['a procedure for testing something'],
      });

      final docRef = MockDocumentReference();
      when(() => mockDictionaryCollection.doc('test')).thenReturn(docRef);
      when(() => docRef.get()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50)); // Significant delay for first lookup
        return mockDoc;
      });

      // First lookup (uncached)
      final firstLookup = Stopwatch()..start();
      await dictionaryService.lookupWord('test', 'es');
      firstLookup.stop();

      // Second lookup (should be cached)
      final secondLookup = Stopwatch()..start();
      await dictionaryService.lookupWord('test', 'es');
      secondLookup.stop();

      // Cached lookup should be significantly faster
      expect(secondLookup.elapsedMilliseconds, lessThan(firstLookup.elapsedMilliseconds ~/ 2),
          reason: 'Cached lookups should be at least twice as fast');
    });

    test('handles concurrent lookups efficiently', () async {
      // Setup mock data for concurrent lookups
      final mockDoc = MockDocumentSnapshot();
      when(() => mockDoc.exists).thenReturn(true);
      when(() => mockDoc.data()).thenReturn({
        'word': 'test',
        'translation': 'prueba',
        'language': 'es',
        'definitions': ['a procedure for testing something'],
      });

      final docRef = MockDocumentReference();
      when(() => mockDictionaryCollection.doc(any())).thenReturn(docRef);
      when(() => docRef.get()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 5)); // Small delay per lookup
        return mockDoc;
      });

      final stopwatch = Stopwatch()..start();

      // Simulate multiple users looking up the same word concurrently
      await Future.wait(
        List.generate(50, (i) => dictionaryService.lookupWord('test', 'es'))
      );

      stopwatch.stop();

      // Performance threshold: 1 second for 50 concurrent lookups
      expect(stopwatch.elapsedMilliseconds, lessThan(1000),
          reason: '50 concurrent lookups should complete within 1 second');
    });

    test('maintains performance with large result sets', () async {
      // Setup mock data with large definition list
      final mockDoc = MockDocumentSnapshot();
      when(() => mockDoc.exists).thenReturn(true);
      when(() => mockDoc.data()).thenReturn({
        'word': 'test',
        'translation': 'prueba',
        'language': 'es',
        'definitions': List.generate(100, (i) => 'Definition $i: ${List.generate(50, (j) => 'word').join(' ')}'),
        'examples': List.generate(50, (i) => 'Example $i: ${List.generate(20, (j) => 'word').join(' ')}'),
        'synonyms': List.generate(30, (i) => 'synonym$i'),
      });

      final docRef = MockDocumentReference();
      when(() => mockDictionaryCollection.doc('test')).thenReturn(docRef);
      when(() => docRef.get()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 20)); // Delay for large data
        return mockDoc;
      });

      final stopwatch = Stopwatch()..start();

      final result = await dictionaryService.lookupWord('test', 'es');

      stopwatch.stop();

      // Performance threshold: 200ms for large result processing
      expect(stopwatch.elapsedMilliseconds, lessThan(200),
          reason: 'Processing large dictionary results should complete within 200ms');
      
      // Verify result size and structure
      expect(result, isA<DictionaryResult>());
      expect(result.word, equals('test'));
      expect(result.translation, equals('prueba'));
      expect(result.language, equals('es'));
      expect(result.definitions.length, equals(100));
      expect(result.examples.length, equals(50));
      expect(result.synonyms.length, equals(30));

      // Verify cache is working
      expect(dictionaryService.hasCached('test', 'es'), isTrue);
    });
  });
}
