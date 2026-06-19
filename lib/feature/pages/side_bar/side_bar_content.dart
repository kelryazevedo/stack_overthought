import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/side_bar/side_bar_item.dart';

class SideBarContent extends StatelessWidget {
  const SideBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StackOverthoughtCubit>();
    final notes = cubit.state.notes ?? [];
    final activeTags = cubit.activeTags;

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const Divider(),

        ...activeTags.map((tag) {
          final count = notes.where((note) => note.tag.id == tag.id).length;

          return SidebarItem(tag: tag, count: count);
        }),
      ],
    );
  }
}
