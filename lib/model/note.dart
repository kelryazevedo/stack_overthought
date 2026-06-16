import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_controller.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String title;
  final Tag tag;
  final String excerpt;
  final String content;
  final DateTime date;
  final String? image;

  Note({
    required this.title,
    required this.tag,
    required this.excerpt,
    required this.content,
    required this.date,
    this.image,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

final sampleNotes = <Note>[
  Note(
    title: 'Reunião Q4 — Estratégia de produto',
    tag: Tag.work,
    excerpt:
        'Discutir o roadmap para o próximo trimestre, prioridades de engineering e alinhamento com marketing...',
    content:
        'Pontos chave:\n• Lançamento feature X em Setembro\n• Revisão de métricas de retenção\n• Budget para Q4 a confirmar\n• Onboarding redesign — João lidera',
    date: DateTime.now(),
  ),
  Note(
    title: 'App de meditação — conceito de UI',
    tag: Tag.ideas,
    excerpt:
        'Paleta de cores minimalista com azul profundo e branco. Animações suaves de respiração...',
    content: 'Notas de design e interações',
    date: DateTime.now(),
  ),
];

extension TagX on Tag {
  String get label {
    switch (this) {
      case Tag.work:
        return 'Trabalho';
      case Tag.personal:
        return 'Pessoal';
      case Tag.ideas:
        return 'Ideias';
      case Tag.urgent:
        return 'Urgente';
    }
  }

  Color get color {
    switch (this) {
      case Tag.work:
        return const Color(0xFFEF9F27);
      case Tag.personal:
        return const Color(0xFF4DB6AC);
      case Tag.ideas:
        return const Color(0xFF7C4DFF);
      case Tag.urgent:
        return const Color(0xFFD32F2F);
    }
  }

  Color get backgroundColor {
    return color.withOpacity(0.16);
  }
}
