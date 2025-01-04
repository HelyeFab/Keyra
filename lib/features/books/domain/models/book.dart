import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'book_language.dart';
import 'book_page.dart';

part 'book.g.dart';

@HiveType(typeId: 0, adapterName: 'BookAdapter')
class Book extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Map<BookLanguage, String> title;
  @HiveField(2)
  final String coverImage;
  @HiveField(3)
  final List<BookPage> pages;
  @HiveField(4)
  final BookLanguage defaultLanguage;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final bool isFavorite;
  @HiveField(7)
  final String author;
  @HiveField(8)
  final String fileUrl;
  @HiveField(9)
  final String description;
  @HiveField(10)
  final List<String> categories;
  @HiveField(11)
  final BookLanguage currentLanguage;
  @HiveField(12)
  final int currentPage;
  @HiveField(13)
  final bool isAudioPlaying;
  @HiveField(14)
  final DateTime? lastReadAt;
  @HiveField(15)
  final double readingProgress;

  const Book({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pages,
    this.defaultLanguage = BookLanguage.english,
    required this.createdAt,
    this.isFavorite = false,
    this.author = '',
    this.fileUrl = '',
    this.description = '',
    this.categories = const [],
    this.currentLanguage = BookLanguage.english,
    this.currentPage = 0,
    this.isAudioPlaying = false,
    this.lastReadAt,
    this.readingProgress = 0.0,
  });

  String getTitle(BookLanguage language) {
    return title[language] ?? title[BookLanguage.english] ?? '';
  }

  BookPage? get currentPageContent {
    if (currentPage >= 0 && currentPage < pages.length) {
      return pages[currentPage];
    }
    return null;
  }

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == pages.length - 1;
  int get totalPages => pages.length;

  Book copyWith({
    String? id,
    Map<BookLanguage, String>? title,
    String? coverImage,
    List<BookPage>? pages,
    BookLanguage? defaultLanguage,
    DateTime? createdAt,
    bool? isFavorite,
    String? author,
    String? fileUrl,
    String? description,
    List<String>? categories,
    BookLanguage? currentLanguage,
    int? currentPage,
    bool? isAudioPlaying,
    DateTime? lastReadAt,
    double? readingProgress,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      pages: pages ?? this.pages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      author: author ?? this.author,
      fileUrl: fileUrl ?? this.fileUrl,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      currentPage: currentPage ?? this.currentPage,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title.map((key, value) => MapEntry(key.code, value)),
      'coverImage': coverImage,
      'pages': pages.map((page) => page.toJson()).toList(),
      'defaultLanguage': defaultLanguage.code,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'author': author,
      'fileUrl': fileUrl,
      'description': description,
      'categories': categories,
      'currentLanguage': currentLanguage.code,
      'currentPage': currentPage,
      'isAudioPlaying': isAudioPlaying,
      'lastReadAt': lastReadAt?.toIso8601String(),
      'readingProgress': readingProgress,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title.map((key, value) => MapEntry(key.code, value)),
      'coverImage': coverImage,
      'pages': pages.map((page) => page.toJson()).toList(),
      'defaultLanguage': defaultLanguage.code,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFavorite': isFavorite,
      'author': author,
      'fileUrl': fileUrl,
      'description': description,
      'categories': categories,
      'currentLanguage': currentLanguage.code,
      'currentPage': currentPage,
      'isAudioPlaying': isAudioPlaying,
      'lastReadAt': lastReadAt != null ? Timestamp.fromDate(lastReadAt!) : null,
      'readingProgress': readingProgress,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: (json['title'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(BookLanguage.fromCode(key), value as String),
      ),
      coverImage: json['coverImage'] as String,
      pages: (json['pages'] as List<dynamic>)
          .map((page) => BookPage.fromJson(page as Map<String, dynamic>))
          .toList(),
      defaultLanguage: BookLanguage.fromCode(json['defaultLanguage'] as String),
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool,
      author: json['author'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      currentLanguage: BookLanguage.fromCode(json['currentLanguage'] as String),
      currentPage: json['currentPage'] as int,
      isAudioPlaying: json['isAudioPlaying'] as bool,
      lastReadAt: json['lastReadAt'] != null
          ? json['lastReadAt'] is Timestamp 
              ? (json['lastReadAt'] as Timestamp).toDate()
              : DateTime.parse(json['lastReadAt'] as String)
          : null,
      readingProgress: json['readingProgress'] as double,
    );
  }

  factory Book.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Book(
      id: docId ?? map['id'] as String? ?? '',
      title: (map['title'] as Map<String, dynamic>).map(
        (key, value) {
          // Always convert key to string first, then to BookLanguage
          final bookLanguage = BookLanguage.fromCode(key.toString());
          return MapEntry(bookLanguage, value as String);
        },
      ),
      coverImage: map['coverImage'] as String? ?? '',
      pages: (map['pages'] as List<dynamic>)
          .map((page) => BookPage.fromJson(page as Map<String, dynamic>))
          .toList(),
      defaultLanguage: BookLanguage.fromCode(map['defaultLanguage'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isFavorite: map['isFavorite'] as bool? ?? false,
      author: map['author'] as String? ?? '',
      fileUrl: map['fileUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      currentLanguage: BookLanguage.fromCode(map['currentLanguage'] as String? ?? map['defaultLanguage'] as String),
      currentPage: map['currentPage'] as int? ?? 0,
      isAudioPlaying: map['isAudioPlaying'] as bool? ?? false,
      lastReadAt: map['lastReadAt'] != null
          ? (map['lastReadAt'] as Timestamp).toDate()
          : null,
      readingProgress: (map['readingProgress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        coverImage,
        pages,
        defaultLanguage,
        createdAt,
        isFavorite,
        author,
        fileUrl,
        description,
        categories,
        currentLanguage,
        currentPage,
        isAudioPlaying,
        lastReadAt,
        readingProgress,
      ];
}
