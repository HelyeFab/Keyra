class ReadingProgress {
  final String bookId;
  final String userId;
  final int currentPage;
  final int totalPages;
  final DateTime lastReadTimestamp;

  ReadingProgress({
    required this.bookId,
    required this.userId,
    required this.currentPage,
    required this.totalPages,
    required this.lastReadTimestamp,
  });

  factory ReadingProgress.fromMap(Map<String, dynamic> map) {
    return ReadingProgress(
      bookId: map['bookId'] as String,
      userId: map['userId'] as String,
      currentPage: map['currentPage'] as int,
      totalPages: map['totalPages'] as int,
      lastReadTimestamp: DateTime.parse(map['lastReadTimestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'userId': userId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'lastReadTimestamp': lastReadTimestamp.toIso8601String(),
    };
  }

  double get progressPercentage => (currentPage / totalPages) * 100;

  ReadingProgress copyWith({
    String? bookId,
    String? userId,
    int? currentPage,
    int? totalPages,
    DateTime? lastReadTimestamp,
  }) {
    return ReadingProgress(
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      lastReadTimestamp: lastReadTimestamp ?? this.lastReadTimestamp,
    );
  }
}
