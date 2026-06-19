// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
  title: json['title'] as String,
  tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
  excerpt: json['excerpt'] as String,
  content: json['content'] as String,
  date: json['date'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'title': instance.title,
  'tag': instance.tag,
  'excerpt': instance.excerpt,
  'content': instance.content,
  'date': instance.date,
  'image': instance.image,
};
