import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/notes/note_card_content.dart';
import 'package:stack_overthought/feature/pages/shared_widget/tag_flag_widget.dart';

class HomeGridNoteScreen extends StatefulWidget {
  const HomeGridNoteScreen({super.key});

  @override
  State<HomeGridNoteScreen> createState() => _HomeGridNoteScreenState();
}

class _HomeGridNoteScreenState extends State<HomeGridNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final stackOverthoughtCubit = context.watch<StackOverthoughtCubit>();
    final notes = stackOverthoughtCubit.filteredNotes;

    return Expanded(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return InkWell(
            onTap: () => stackOverthoughtCubit.selectNote(note),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagFlagWidget(tag: note.tag),
                    NoteCardContent(note: note),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
