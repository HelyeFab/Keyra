class ExampleSentence {
  final String japanese;
  final String english;

  const ExampleSentence({
    required this.japanese,
    required this.english,
  });

  factory ExampleSentence.fromJson(Map<String, dynamic> json) {
    return ExampleSentence(
      japanese: json['japanese'] as String,
      english: json['english'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'japanese': japanese,
    'english': english,
  };
}
