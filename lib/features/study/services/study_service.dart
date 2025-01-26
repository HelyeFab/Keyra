import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../models/word_status.dart';
import '../models/study_session.dart';

class StudyFailure {
  final String code;
  final String message;

  StudyFailure({required this.code, required this.message});
}

class StudyStats {
  final int totalSessions;
  final int totalWordsReviewed;
  final double averageAccuracy;

  StudyStats({
    required this.totalSessions,
    required this.totalWordsReviewed,
    required this.averageAccuracy,
  });
}

class StudyService {
  final FirebaseFirestore firestore;
  final User currentUser;

  StudyService({
    required this.firestore,
    required this.currentUser,
  });

  DateTime calculateNextReviewDate(WordStatus status, DateTime currentDate) {
    switch (status) {
      case WordStatus.initial:
        return currentDate;
      case WordStatus.learning:
        return currentDate.add(const Duration(days: 1));
      case WordStatus.reviewing:
        return currentDate.add(const Duration(days: 3));
      case WordStatus.mastered:
        return currentDate.add(const Duration(days: 7));
    }
  }

  Future<Either<StudyFailure, List<StudyWord>>> getWordsForReview() async {
    try {
      final snapshot = await firestore
          .collection('study_words')
          .where('userId', isEqualTo: currentUser.uid)
          .where('nextReviewDate', isLessThanOrEqualTo: DateTime.now())
          .get();

      final words = snapshot.docs
          .map((doc) => StudyWord.fromMap(doc.data(), doc.id))
          .toList();

      return Right(words);
    } catch (e) {
      return Left(StudyFailure(
        code: 'fetch-words-error',
        message: 'Failed to fetch words for review: ${e.toString()}',
      ));
    }
  }

  Future<Either<StudyFailure, void>> updateWordStatus({
    required String wordId,
    required WordStatus newStatus,
    required DateTime reviewDate,
  }) async {
    try {
      final nextReview = calculateNextReviewDate(newStatus, reviewDate);
      
      await firestore.collection('study_words').doc(wordId).update({
        'status': newStatus.toJson(),
        'nextReviewDate': nextReview.toIso8601String(),
        'reviewCount': FieldValue.increment(1),
      });

      return const Right(null);
    } catch (e) {
      return Left(StudyFailure(
        code: 'update-status-error',
        message: 'Failed to update word status: ${e.toString()}',
      ));
    }
  }

  Future<Either<StudyFailure, StudySession>> createStudySession(
    List<StudyWord> words,
  ) async {
    try {
      final docRef = firestore.collection('study_sessions').doc();
      final session = StudySession(
        id: docRef.id,
        userId: currentUser.uid,
        startTime: DateTime.now(),
        words: words,
      );

      await docRef.set(session.toMap());
      return Right(session);
    } catch (e) {
      return Left(StudyFailure(
        code: 'create-session-error',
        message: 'Failed to create study session: ${e.toString()}',
      ));
    }
  }

  Future<Either<StudyFailure, void>> completeStudySession({
    required String sessionId,
    required DateTime completionTime,
    required int wordsReviewed,
    required int correctAnswers,
  }) async {
    try {
      final accuracy = correctAnswers / wordsReviewed;
      await firestore.collection('study_sessions').doc(sessionId).update({
        'endTime': completionTime.toIso8601String(),
        'wordsReviewed': wordsReviewed,
        'correctAnswers': correctAnswers,
        'accuracy': accuracy,
      });

      return const Right(null);
    } catch (e) {
      return Left(StudyFailure(
        code: 'complete-session-error',
        message: 'Failed to complete study session: ${e.toString()}',
      ));
    }
  }

  Future<Either<StudyFailure, StudyStats>> getStudyStats() async {
    try {
      final snapshot = await firestore
          .collection('study_sessions')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('startTime', descending: true)
          .limit(30)
          .get();

      if (snapshot.docs.isEmpty) {
        return Right(StudyStats(
          totalSessions: 0,
          totalWordsReviewed: 0,
          averageAccuracy: 0.0,
        ));
      }

      var totalWordsReviewed = 0;
      var totalCorrectAnswers = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        totalWordsReviewed += (data['wordsReviewed'] as int?) ?? 0;
        totalCorrectAnswers += (data['correctAnswers'] as int?) ?? 0;
      }

      final stats = StudyStats(
        totalSessions: snapshot.docs.length,
        totalWordsReviewed: totalWordsReviewed,
        averageAccuracy: totalWordsReviewed > 0
            ? totalCorrectAnswers / totalWordsReviewed
            : 0.0,
      );

      return Right(stats);
    } catch (e) {
      return Left(StudyFailure(
        code: 'get-stats-error',
        message: 'Failed to get study statistics: ${e.toString()}',
      ));
    }
  }
}
