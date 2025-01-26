import 'package:hive/hive.dart';
import '../../domain/models/book.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return Book.fromMap(map, docId: map['id'] as String);
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer.writeMap({
      ...obj.toMap(),
      'id': obj.id,
    });
  }
}
