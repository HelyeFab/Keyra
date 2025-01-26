class KanjiDictEntry {
  final String literal;
  final List<String> meanings;
  final Map<String, List<String>> readings;
  final int? grade;
  final int? jlpt;
  final int? strokeCount;

  const KanjiDictEntry({
    required this.literal,
    required this.meanings,
    required this.readings,
    this.grade,
    this.jlpt,
    this.strokeCount,
  });

  factory KanjiDictEntry.fromJson(Map<String, dynamic> json) {
    return KanjiDictEntry(
      literal: json['literal'] as String,
      meanings: List<String>.from(json['meanings'] as List),
      readings: {
        'on': List<String>.from(json['readings']['on'] as List),
        'kun': List<String>.from(json['readings']['kun'] as List),
      },
      grade: json['grade'] as int?,
      jlpt: json['jlpt'] as int?,
      strokeCount: json['stroke_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'literal': literal,
    'meanings': meanings,
    'readings': readings,
    'grade': grade,
    'jlpt': jlpt,
    'stroke_count': strokeCount,
  };
}
