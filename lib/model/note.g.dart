// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
  title: json['title'] as String,
  tag: $enumDecode(_$TagEnumMap, json['tag']),
  excerpt: json['excerpt'] as String,
  content: json['content'] as String,
  date: DateTime.parse(json['date'] as String),
  image: json['image'] as String?,
);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'title': instance.title,
  'tag': _$TagEnumMap[instance.tag],
  'excerpt': instance.excerpt,
  'content': instance.content,
  'date': instance.date.toIso8601String(),
  'image': instance.image,
};

const _$TagEnumMap = {
  Tag.work: 'work',
  Tag.personal: 'personal',
  Tag.ideas: 'ideas',
  Tag.urgent: 'urgent',
};
