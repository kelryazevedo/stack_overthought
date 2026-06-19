import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/model/tag.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String title;
  final Tag tag;
  final String excerpt;
  final String content;
  final String? date;
  final String? image;

  Note({
    required this.title,
    required this.tag,
    required this.excerpt,
    required this.content,
    required this.date,
    this.image,
  });

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
