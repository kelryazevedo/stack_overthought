import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_overthought/core/ui_core/app_color.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';
import 'package:stack_overthought/feature/pages/home/home_grid_note.dart';
import 'package:stack_overthought/feature/pages/home/home_header.dart';
import 'package:stack_overthought/feature/pages/notes/note_expanded.dart';
import 'package:stack_overthought/feature/pages/side_bar/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StackOverthoughtCubit, StackOverthoughtState>(
          bloc: context.read<StackOverthoughtCubit>(),
          builder: (context, state) {
            return Row(
              spacing: 16,
              children: [
                const SideBar(),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.all(24),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [HomeHeader(), HomeGridNoteScreen()],
                    ),
                  ),
                ),

                // Right detail panel
                const NoteExpanded(),
              ],
            );
          },
        ),
      ),
    );
  }
}
