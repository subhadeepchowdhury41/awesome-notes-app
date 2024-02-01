import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? color;

  Note({
    this.id,
    this.title,
    this.color,
  });

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
        id: data['_id'], title: data['title'], color: data['color']);
  }
}