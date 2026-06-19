import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/shared_widget/dropdown_tags.dart';
import 'package:stack_overthought/feature/pages/shared_widget/image_section.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController titleCtrl;
  late TextEditingController excerptCtrl;
  late TextEditingController contentCtrl;
  late Tag selectedTag;
  late Note originalNote;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<StackOverthoughtCubit>();
    originalNote = cubit.state.selectedNote!;

    titleCtrl = TextEditingController(text: originalNote.title);
    excerptCtrl = TextEditingController(text: originalNote.excerpt);
    contentCtrl = TextEditingController(text: originalNote.content);
    selectedTag = originalNote.tag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(editNoteTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImageSection(),
              const Text('$editNoteTitle *', style: AppTextStyle.title),
              TextField(
                enabled: false,
                controller: titleCtrl,
                decoration: InputDecoration(
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                maxLines: 2,
              ),
              const Text(contentTitle, style: AppTextStyle.description),
              TextField(
                controller: contentCtrl,
                decoration: InputDecoration(
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
                      onPressed: () => _updateNote(),
                      child: const Text(saveChanges),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateNote() {
    final cubit = context.read<StackOverthoughtCubit>();
    final newImage =
        cubit.state.selectedNote?.image ??
        cubit.state.loadingImage ??
        originalNote.image;

    final newNote = Note(
      title: titleCtrl.text.trim(),
      tag: selectedTag,
      excerpt: excerptCtrl.text.trim(),
      content: contentCtrl.text.trim(),
      date: originalNote.date,
      image: newImage,
    );

    cubit.editNote(newNote);
    context.pop();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    excerptCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }
}
