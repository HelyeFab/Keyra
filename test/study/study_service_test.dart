import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/features/study/services/study_service.dart';
import 'package:Keyra/features/study/models/study_session.dart';
import 'package:Keyra/features/study/models/word_status.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

void main() {
  late StudyService studyService;
  late MockFirestore mockFirestore;
  late MockCollectionReference mockWordsCollection;
  late MockCollectionReference mockSessionsCollection;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(FieldValue.increment(1));
  });

  setUp(() {
    mockFirestore = MockFirestore();
    mockWordsCollection = MockCollectionReference();
    mockSessionsCollection = MockCollectionReference();
    mockUser = MockUser();

    when(() => mockFirestore.collection('study_words'))
        .thenReturn(mockWordsCollection);
    when(() => mockFirestore.collection('study_sessions'))
        .thenReturn(mockSessionsCollection);
    when(() => mockUser.uid).thenReturn('test-user-id');

    studyService = StudyService(
      firestore: mockFirestore,
      currentUser: mockUser,
    );
  });

  group('Study Service Tests', () {
    test('calculateNextReviewDate - follows spaced repetition algorithm', () {
      final now = DateTime.now();
      
      expect(
        studyService.calculateNextReviewDate(WordStatus.initial, now),
        now,
      );

      expect(
        studyService.calculateNextReviewDate(WordStatus.learning, now),
        now.add(const Duration(days: 1)),
      );

      expect(
        studyService.calculateNextReviewDate(WordStatus.reviewing, now),
        now.add(const Duration(days: 3)),
      );

      expect(
        studyService.calculateNextReviewDate(WordStatus.mastered, now),
        now.add(const Duration(days: 7)),
      );
    });

    test('getWordsForReview - returns words due for review', () async {
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      final now = DateTime.now();

      final query1 = MockQuery();
      final query2 = MockQuery();
      
      when(() => mockWordsCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(query1);
      when(() => query1.where(any(), isLessThanOrEqualTo: any(named: 'isLessThanOrEqualTo')))
          .thenReturn(query2);
      when(() => query2.get()).thenAnswer((_) async => mockQuerySnapshot);
      
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn(<String, dynamic>{
        'word': 'test',
        'translation': 'prueba',
        'context': 'This is a test.',
        'status': 'learning',
        'nextReviewDate': now.toIso8601String(),
        'reviewCount': 1,
        'userId': 'test-user-id',
      });
      when(() => mockQueryDocSnapshot.id).thenReturn('word-1');

      final result = await studyService.getWordsForReview();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (words) {
          expect(words.length, 1);
          expect(words.first.word, 'test');
          expect(words.first.status, WordStatus.learning);
        },
      );
    });

    test('updateWordStatus - updates status and next review date', () async {
      final mockDocRef = MockDocumentReference();
      final now = DateTime.now();

      when(() => mockWordsCollection.doc('word-1'))
          .thenReturn(mockDocRef);
      when(() => mockDocRef.update(any<Map<String, dynamic>>()))
          .thenAnswer((_) async => Future<void>.value());

      final result = await studyService.updateWordStatus(
        wordId: 'word-1',
        newStatus: WordStatus.reviewing,
        reviewDate: now,
      );

      expect(result.isRight(), true);
      
      final captured = verify(() => mockDocRef.update(captureAny())).captured.single;
      
      expect(captured['status'], equals('reviewing'));
      expect(
        DateTime.parse(captured['nextReviewDate'] as String).isAfter(now), 
        isTrue,
        reason: 'Next review date should be after current time'
      );
      expect(captured['reviewCount'], equals(FieldValue.increment(1)));
    });

    test('createStudySession - creates new session with words', () async {
      final mockDocRef = MockDocumentReference();
      final now = DateTime.now();
      final words = [
        StudyWord(
          id: 'word-1',
          word: 'test',
          translation: 'prueba',
          context: 'This is a test.',
          status: WordStatus.learning,
          nextReviewDate: now,
          reviewCount: 1,
        ),
      ];

      when(() => mockSessionsCollection.doc())
          .thenReturn(mockDocRef);
      when(() => mockDocRef.set(any<Map<String, dynamic>>()))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockDocRef.id).thenReturn('session-1');

      final result = await studyService.createStudySession(words);

      expect(result.isRight(), true);
      
      final captured = verify(() => mockDocRef.set(captureAny<Map<String, dynamic>>()))
          .captured.single as Map<String, dynamic>;
      
      expect(captured['userId'], equals('test-user-id'));
      expect(captured['startTime'], isNotNull);
      expect(captured['words'], isA<List>());
      expect(captured['words'].length, equals(1));
      
      final capturedWord = (captured['words'] as List).first as Map<String, dynamic>;
      expect(capturedWord['word'], equals('test'));
      expect(capturedWord['translation'], equals('prueba'));
      expect(capturedWord['status'], equals('learning'));
    });

    test('completeStudySession - updates session completion data', () async {
      final mockDocRef = MockDocumentReference();
      final now = DateTime.now();

      when(() => mockSessionsCollection.doc('session-1'))
          .thenReturn(mockDocRef);
      when(() => mockDocRef.update(any<Map<String, dynamic>>()))
          .thenAnswer((_) async => Future<void>.value());

      final result = await studyService.completeStudySession(
        sessionId: 'session-1',
        completionTime: now,
        wordsReviewed: 10,
        correctAnswers: 8,
      );

      expect(result.isRight(), true);
      
      final captured = verify(() => mockDocRef.update(captureAny())).captured.single;
      
      expect(captured['endTime'], equals(now.toIso8601String()));
      expect(captured['wordsReviewed'], equals(10));
      expect(captured['correctAnswers'], equals(8));
      expect(captured['accuracy'], equals(0.8));
    });

    test('getStudyStats - returns user study statistics', () async {
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      final query1 = MockQuery();
      final query2 = MockQuery();
      final query3 = MockQuery();

      when(() => mockSessionsCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(query1);
      when(() => query1.orderBy(any(), descending: any(named: 'descending')))
          .thenReturn(query2);
      when(() => query2.limit(30))
          .thenReturn(query3);
      when(() => query3.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn(<String, dynamic>{
        'startTime': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'endTime': DateTime.now().toIso8601String(),
        'wordsReviewed': 10,
        'correctAnswers': 8,
        'accuracy': 0.8,
      });

      final result = await studyService.getStudyStats();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (stats) {
          expect(stats.totalSessions, 1);
          expect(stats.totalWordsReviewed, 10);
          expect(stats.averageAccuracy, 0.8);
        },
      );
    });
  });
}
