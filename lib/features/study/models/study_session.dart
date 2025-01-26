import 'word_status.dart';

class StudyWord {
  final String id;
  final String word;
  final String translation;
  final String context;
  final WordStatus status;
  final DateTime nextReviewDate;
  final int reviewCount;

  StudyWord({
    required this.id,
    required this.word,
    required this.translation,
    required this.context,
    required this.status,
    required this.nextReviewDate,
    required this.reviewCount,
  });

  factory StudyWord.fromMap(Map<String, dynamic> map, String id) {
    return StudyWord(
      id: id,
      word: map['word'] as String,
      translation: map['translation'] as String,
      context: map['context'] as String,
      status: WordStatus.fromJson(map['status'] as String),
      nextReviewDate: DateTime.parse(map['nextReviewDate'] as String),
      reviewCount: map['reviewCount'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'context': context,
      'status': status.toJson(),
      'nextReviewDate': nextReviewDate.toIso8601String(),
      'reviewCount': reviewCount,
    };
  }

  StudyWord copyWith({
    String? id,
    String? word,
    String? translation,
    String? context,
    WordStatus? status,
    DateTime? nextReviewDate,
    int? reviewCount,
  }) {
    return StudyWord(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      context: context ?? this.context,
      status: status ?? this.status,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

class StudySession {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<StudyWord> words;
  final int? wordsReviewed;
  final int? correctAnswers;
  final double? accuracy;

  StudySession({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.words,
    this.wordsReviewed,
    this.correctAnswers,
    this.accuracy,
  });

  factory StudySession.fromMap(Map<String, dynamic> map, String id) {
    return StudySession(
      id: id,
      userId: map['userId'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null 
        ? DateTime.parse(map['endTime'] as String)
        : null,
      words: (map['words'] as List<dynamic>)
        .map((word) => StudyWord.fromMap(
          word as Map<String, dynamic>,
          word['id'] as String,
        ))
        .toList(),
      wordsReviewed: map['wordsReviewed'] as int?,
      correctAnswers: map['correctAnswers'] as int?,
      accuracy: map['accuracy'] as double?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'words': words.map((word) => word.toMap()).toList(),
      'wordsReviewed': wordsReviewed,
      'correctAnswers': correctAnswers,
      'accuracy': accuracy,
    };
  }

  StudySession copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    List<StudyWord>? words,
    int? wordsReviewed,
    int? correctAnswers,
    double? accuracy,
  }) {
    return StudySession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      words: words ?? this.words,
      wordsReviewed: wordsReviewed ?? this.wordsReviewed,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}
