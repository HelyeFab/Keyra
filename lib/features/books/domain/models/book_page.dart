import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

part 'book_page.g.dart';

@HiveType(typeId: 2, adapterName: 'BookPageAdapter')
class BookPage extends Equatable {
  @HiveField(0)
  final Map<BookLanguage, String> text;
  @HiveField(1)
  final Map<BookLanguage, String> audioPath;
  @HiveField(2)
  final String? imagePath;

  const BookPage({
    required this.text,
    required this.audioPath,
    this.imagePath,
  });

  String getText(String languageCode) {
    // Convert language code to BookLanguage
    final language = BookLanguage.values.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => BookLanguage.english,
    );

    // Try to get text for the requested language
    final requestedText = text[language];
    if (requestedText != null && requestedText.isNotEmpty) {
      return requestedText;
    }

    // If furigana was requested but not found, fall back to regular Japanese
    if (language == BookLanguage.japaneseFurigana) {
      return text[BookLanguage.japanese] ?? '';
    }

    // Default fallback
    return '';
  }

  String? getAudioPath(String languageCode) {
    // Regular language handling
    final language = BookLanguage.values.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => BookLanguage.english,
    );
    return audioPath[language];
  }

  BookPage copyWith({
    Map<BookLanguage, String>? text,
    Map<BookLanguage, String>? audioPath,
    String? imagePath,
  }) {
    return BookPage(
      text: text ?? this.text,
      audioPath: audioPath ?? this.audioPath,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text.map((key, value) => MapEntry(key.code, value)),
      'audioPath': audioPath.map((key, value) => MapEntry(key.code, value)),
      'imagePath': imagePath,
    };
  }

  factory BookPage.fromJson(Map<String, dynamic> json) {
    return BookPage(
      text: (json['text'] as Map<String, dynamic>).map(
        (key, value) {
          // Always convert key to string first, then to BookLanguage
          final bookLanguage = BookLanguage.fromCode(key.toString());
          return MapEntry(bookLanguage, value as String);
        },
      ),
      audioPath: (json['audioPath'] as Map<String, dynamic>?)?.map(
        (key, value) {
          final bookLanguage = BookLanguage.fromCode(key.toString());
          return MapEntry(bookLanguage, value as String);
        },
      ) ?? {},
      imagePath: json['imagePath'] as String?,
    );
  }

  @override
  List<Object?> get props => [text, audioPath, imagePath];
}
