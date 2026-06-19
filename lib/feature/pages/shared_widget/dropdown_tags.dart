import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_overthought/core/ui_core/app_extension.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/model/tag.dart';

class DropdownTags extends StatefulWidget {
  final Tag selectedTag;
  final ValueChanged<Tag> onTagChanged;

  const DropdownTags({
    super.key,
    required this.selectedTag,
    required this.onTagChanged,
  });

  @override
  State<DropdownTags> createState() => _DropdownTagsState();
}

class _DropdownTagsState extends State<DropdownTags> {
  late String selectedTagId;

  @override
  void initState() {
    super.initState();
    selectedTagId = widget.selectedTag.id;
  }

  @override
  Widget build(BuildContext context) {
    final availableTags =
        context.watch<StackOverthoughtCubit>().state.availableTags ?? [];

    return DropdownButtonFormField<String>(
      initialValue: selectedTagId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
      ),
      items: availableTags.map((tag) {
        return DropdownMenuItem<String>(
          value: tag.id,
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
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedTagId = value;
        });

        final selectedTag = availableTags.firstWhere((t) => t.id == value);
        widget.onTagChanged(selectedTag);
      },
    );
  }
}
