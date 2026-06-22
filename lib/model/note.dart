import 'package:json_annotation/json_annotation.dart';
import 'package:stack_overthought/model/tag.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final Tag tag;
  final String date;
  final String? image;

  Note({
    String? id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.tag,
    required this.date,
    this.image,
  }) : id = id ?? const Uuid().v4();

  Note copyWith({
    String? title,
    Tag? tag,
    String? excerpt,
    String? content,
    String? date,
    String? image,
    bool clearImage = false,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      date: date ?? this.date,
      image: clearImage ? null : (image ?? this.image),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
