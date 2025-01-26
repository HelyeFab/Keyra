class Book {
  final String id;
  final String title;
  final String author;
  final String language;
  final String difficulty;
  final String coverUrl;
  final String contentUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.language,
    required this.difficulty,
    required this.coverUrl,
    required this.contentUrl,
  });

  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      id: id,
      title: map['title'] as String,
      author: map['author'] as String,
      language: map['language'] as String,
      difficulty: map['difficulty'] as String,
      coverUrl: map['coverUrl'] as String,
      contentUrl: map['contentUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'language': language,
      'difficulty': difficulty,
      'coverUrl': coverUrl,
      'contentUrl': contentUrl,
    };
  }
}
