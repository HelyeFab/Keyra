// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: (fields[1] as Map).cast<BookLanguage, String>(),
      coverImage: fields[2] as String,
      pages: (fields[3] as List).cast<BookPage>(),
      defaultLanguage: fields[4] as BookLanguage,
      createdAt: fields[5] as DateTime,
      isFavorite: fields[6] as bool,
      author: fields[7] as String,
      fileUrl: fields[8] as String,
      description: fields[9] as String,
      categories: (fields[10] as List).cast<String>(),
      currentLanguage: fields[11] as BookLanguage,
      currentPage: fields[12] as int,
      isAudioPlaying: fields[13] as bool,
      lastReadAt: fields[14] as DateTime?,
      readingProgress: fields[15] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.coverImage)
      ..writeByte(3)
      ..write(obj.pages)
      ..writeByte(4)
      ..write(obj.defaultLanguage)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.author)
      ..writeByte(8)
      ..write(obj.fileUrl)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.categories)
      ..writeByte(11)
      ..write(obj.currentLanguage)
      ..writeByte(12)
      ..write(obj.currentPage)
      ..writeByte(13)
      ..write(obj.isAudioPlaying)
      ..writeByte(14)
      ..write(obj.lastReadAt)
      ..writeByte(15)
      ..write(obj.readingProgress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
