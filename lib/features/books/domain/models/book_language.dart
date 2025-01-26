import 'package:hive/hive.dart';

part 'book_language.g.dart';

@HiveType(typeId: 1, adapterName: 'BookLanguageAdapter')
enum BookLanguage {
  @HiveField(0)
  english('en', 'English'),
  @HiveField(1)
  french('fr', 'Français'),
  @HiveField(2)
  spanish('es', 'Español'),
  @HiveField(3)
  italian('it', 'Italiano'),
  @HiveField(4)
  german('de', 'Deutsch'),
  @HiveField(5)
  japanese('ja', '日本語');

  final String code;
  final String displayName;

  const BookLanguage(this.code, this.displayName);

  String get flagAsset {
    switch (this) {
      case BookLanguage.english:
        return 'assets/flags/united-kingdom.png';
      case BookLanguage.french:
        return 'assets/flags/france.png';
      case BookLanguage.spanish:
        return 'assets/flags/spain.png';
      case BookLanguage.italian:
        return 'assets/flags/italy.png';
      case BookLanguage.german:
        return 'assets/flags/germany.png';
      case BookLanguage.japanese:
        return 'assets/flags/japan.png';
    }
  }

  static BookLanguage fromCode(String? code) {
    if (code == null) return BookLanguage.english;
    return BookLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => BookLanguage.english,
    );
  }
}
