import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_word.freezed.dart';
part 'saved_word.g.dart';

DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);

DateTime? _nullableTimestampToDateTime(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _nullableDateTimeToTimestamp(DateTime? dateTime) => 
    dateTime != null ? Timestamp.fromDate(dateTime) : null;

@freezed
class SavedWord with _$SavedWord {
  const SavedWord._();

  const factory SavedWord({
    required String id,
    required String word,
    required String definition,
    required String language,
    required List<String> examples,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime savedAt,
    @Default(0) int progress,    // 0 = new, 1 = learning, 2 = learned
    @Default(0) int difficulty,  // 0 = hard, 1 = good, 2 = easy
    @JsonKey(fromJson: _nullableTimestampToDateTime, toJson: _nullableDateTimeToTimestamp)
    DateTime? lastReviewed,
    @Default(0) int repetitions,  // Number of times reviewed
    @Default(2.5) double easeFactor,  // SuperMemo easiness factor
    @Default(1) int interval,  // Current interval in days
  }) = _SavedWord;

  factory SavedWord.fromJson(Map<String, dynamic> json) =>
      _$SavedWordFromJson(json);

  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'definition': definition,
      'language': language.toLowerCase(),
      'examples': examples,
      'savedAt': Timestamp.fromDate(savedAt),
      'progress': progress,
      'difficulty': difficulty,
      'lastReviewed': lastReviewed != null ? Timestamp.fromDate(lastReviewed!) : null,
      'repetitions': repetitions,
      'easeFactor': easeFactor,
      'interval': interval,
    };
  }

  factory SavedWord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavedWord(
      id: doc.id,
      word: data['word'] as String,
      definition: data['definition'] as String,
      language: data['language'] as String,
      examples: List<String>.from(data['examples'] ?? []),
      savedAt: (data['savedAt'] as Timestamp).toDate(),
      progress: data['progress'] as int? ?? 0,
      difficulty: data['difficulty'] as int? ?? 0,
      lastReviewed: data['lastReviewed'] != null ? (data['lastReviewed'] as Timestamp).toDate() : null,
      repetitions: data['repetitions'] as int? ?? 0,
      easeFactor: (data['easeFactor'] as num?)?.toDouble() ?? 2.5,
      interval: data['interval'] as int? ?? 1,
    );
  }

  @override
  String toString() {
    return '$word (Progress: $progress, Difficulty: $difficulty)';
  }
}
