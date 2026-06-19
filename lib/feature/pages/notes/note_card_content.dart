import 'package:flutter/material.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/model/note.dart';

class NoteCardContent extends StatelessWidget {
  final Note note;
  const NoteCardContent({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(note.excerpt),
        Text(note.content, maxLines: 5, overflow: TextOverflow.ellipsis),
        Text(
          note.date.toString(),
          style: AppTextStyle.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
