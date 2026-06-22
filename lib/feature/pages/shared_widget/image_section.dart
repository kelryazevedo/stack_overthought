import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';
import 'package:stack_overthought/model/note.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    final stackOverthoughtCubit = context.read<StackOverthoughtCubit>();

    return BlocBuilder<StackOverthoughtCubit, StackOverthoughtState>(
      buildWhen: (previous, current) =>
          previous.loadingImage != current.loadingImage ||
          previous.selectedNote?.image != current.selectedNote?.image,
      bloc: stackOverthoughtCubit,
      builder: (context, state) {
        final imageToShow = state.selectedNote?.image ?? state.loadingImage;
        final hasImage = imageToShow != null;
        final selectedNote = state.selectedNote;

        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(50),
              width: 2,
            ),
          ),
          child: hasImage
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        base64Decode(imageToShow),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (selectedNote != null) {
                            stackOverthoughtCubit.editNote(
                              selectedNote.copyWith(clearImage: true),
                            );
                          } else {
                            stackOverthoughtCubit.setLoadingImage(null);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () => _pickImage(selectedNote),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text(addImageTitle, style: AppTextStyle.body),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Future<void> _pickImage(Note? selectedNote) async {
    final stackOverthoughtCubit = context.read<StackOverthoughtCubit>();
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (!mounted) return;

    final bytes = result?.files.firstOrNull?.bytes;
    if (bytes == null) return;

    final base64Image = base64Encode(bytes);

    if (selectedNote != null) {
      await stackOverthoughtCubit.editNote(
        selectedNote.copyWith(image: base64Image),
      );
    } else {
      stackOverthoughtCubit.setLoadingImage(base64Image);
    }
  }
}
