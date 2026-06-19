import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_const.dart';
import 'package:stack_overthought/core/ui_core/app_extension.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StackOverthoughtCubit>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(allNotes, style: AppTextStyle.title),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: cubit.setSearchQuery,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: searchNotesHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _openFilterDialog,
                icon: const Icon(Icons.filter_list),
              ),
              ElevatedButton.icon(
                onPressed: () => context.push(Routes.createNote),
                icon: const Icon(Icons.add),
                label: const Text(newNoteTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterDialog() async {
    final stackOverthoughtCubit = context.read<StackOverthoughtCubit>();
    final availableTags = stackOverthoughtCubit.state.availableTags;

    final tagSelected = await showDialog<int?>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(filterByTagTitle),
          children: [
            SimpleDialogOption(
              onPressed: () => context.pop(0),
              child: const Text(allTagsTitle),
            ),
            ...availableTags!.asMap().entries.map((entry) {
              final tag = entry.value;
              final index = entry.key + 1;
              return SimpleDialogOption(
                onPressed: () => context.pop(index),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: tag.parsedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(tag.label),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
    if (tagSelected != null) {
      stackOverthoughtCubit.setTagFilter(
        tagSelected == 0 ? null : availableTags![tagSelected - 1],
      );
    }
  }
}
