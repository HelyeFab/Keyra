// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookPageAdapter extends TypeAdapter<BookPage> {
  @override
  final int typeId = 2;

  @override
  BookPage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookPage(
      text: (fields[0] as Map).cast<BookLanguage, String>(),
      audioPath: (fields[1] as Map).cast<BookLanguage, String>(),
      imagePath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookPage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.audioPath)
      ..writeByte(2)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookPageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
