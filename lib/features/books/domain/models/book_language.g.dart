// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_language.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookLanguageAdapter extends TypeAdapter<BookLanguage> {
  @override
  final int typeId = 1;

  @override
  BookLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookLanguage.english;
      case 1:
        return BookLanguage.french;
      case 2:
        return BookLanguage.spanish;
      case 3:
        return BookLanguage.italian;
      case 4:
        return BookLanguage.german;
      case 5:
        return BookLanguage.japanese;
      default:
        return BookLanguage.english;
    }
  }

  @override
  void write(BinaryWriter writer, BookLanguage obj) {
    switch (obj) {
      case BookLanguage.english:
        writer.writeByte(0);
        break;
      case BookLanguage.french:
        writer.writeByte(1);
        break;
      case BookLanguage.spanish:
        writer.writeByte(2);
        break;
      case BookLanguage.italian:
        writer.writeByte(3);
        break;
      case BookLanguage.german:
        writer.writeByte(4);
        break;
      case BookLanguage.japanese:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
