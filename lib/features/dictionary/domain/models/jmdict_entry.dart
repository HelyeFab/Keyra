import 'example_sentence.dart';

class JMDictEntry {
  final String? kanji;
  final String reading;
  final List<String> meanings;
  final List<String> partsOfSpeech;
  final List<ExampleSentence>? examples;

  const JMDictEntry({
    this.kanji,
    required this.reading,
    required this.meanings,
    required this.partsOfSpeech,
    this.examples,
  });

  factory JMDictEntry.fromJson(Map<String, dynamic> json) {
    return JMDictEntry(
      kanji: json['kanji'] as String?,
      reading: json['reading'] as String,
      meanings: List<String>.from(json['meanings'] as List),
      partsOfSpeech: List<String>.from(json['parts_of_speech'] as List),
      examples: json['examples'] != null
          ? List<ExampleSentence>.from(
              (json['examples'] as List).map((e) => ExampleSentence.fromJson(e as Map<String, dynamic>)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'kanji': kanji,
    'reading': reading,
    'meanings': meanings,
    'parts_of_speech': partsOfSpeech,
    'examples': examples?.map((e) => e.toJson()).toList(),
  };
}
