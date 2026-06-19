import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/core/ui_core/app_extension.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/shared_widget/dropdown_tags.dart';
import 'package:stack_overthought/feature/pages/shared_widget/image_section.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController excerptCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  late Tag selectedTag;
  String? newImage;

  @override
  Widget build(BuildContext context) {
    final stackOverthoughtCubit = context.read<StackOverthoughtCubit>()
      ..setLoadingImage(null)
      ..unselectNote();

    selectedTag = context
        .read<StackOverthoughtCubit>()
        .state
        .availableTags!
        .first;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(newNoteTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageSection(),
            const Text('$titleForm *', style: AppTextStyle.title),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: titleHintForm,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const Text(tagTitle, style: AppTextStyle.description),
            DropdownTags(
              selectedTag: selectedTag,
              onTagChanged: (tag) => selectedTag = tag,
            ),

            const Text(summary, style: AppTextStyle.description),
            TextField(
              controller: excerptCtrl,
              decoration: InputDecoration(
                hintText: briefSummaryHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 2,
            ),
            const Text(contentTitle, style: AppTextStyle.description),
            TextField(
              controller: contentCtrl,
              decoration: InputDecoration(
                hintText: contentNoteHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 6,
            ),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text(cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newNote = _saveNote();
                      if (newNote != null) {
                        stackOverthoughtCubit.addNote(newNote);
                        context.pop();
                      }
                    },
                    child: const Text(createNote),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Note? _saveNote() {
    if (titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(titleRequired)));
      return null;
    }

    final newImage = context.read<StackOverthoughtCubit>().state.loadingImage;
    return Note(
      title: titleCtrl.text.trim(),
      tag: selectedTag,
      excerpt: excerptCtrl.text.trim(),
      content: contentCtrl.text.trim(),
      date: DateTime.now().formatted,
      image: newImage,
    );
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    excerptCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }
}
