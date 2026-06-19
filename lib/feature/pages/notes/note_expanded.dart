import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_color.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/notes/note_action_buttons.dart';
import 'package:stack_overthought/feature/pages/notes/note_card_content.dart';
import 'package:stack_overthought/feature/pages/notes/note_image.dart';
import 'package:stack_overthought/feature/pages/shared_widget/tag_flag_widget.dart';

class NoteExpanded extends StatelessWidget {
  const NoteExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    final selectNote = context
        .watch<StackOverthoughtCubit>()
        .state
        .selectedNote;
    if (selectNote == null) return const SizedBox.shrink();

    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: AppColors.secondary.withAlpha(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NoteImage(imageBase64: selectNote.image),
                  TagFlagWidget(tag: selectNote.tag),
                  Text(selectNote.title, style: AppTextStyle.title),
                  NoteCardContent(note: selectNote),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const NoteActionButtons(),
        ],
      ),
    );
  }
}
