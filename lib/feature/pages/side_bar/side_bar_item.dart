import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_overthought/core/ui_core/app_extension.dart';
import 'package:stack_overthought/core/ui_core/app_text_style.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/model/tag.dart';

class SidebarItem extends StatelessWidget {
  final Tag tag;
  final int count;

  const SidebarItem({super.key, required this.count, required this.tag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<StackOverthoughtCubit>().setTagFilter(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 4,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: tag.parsedColor,
                    shape: BoxShape.circle,
                  ),
                ),

                Text(tag.label, style: TextStyle(color: tag.parsedColor)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tag.parsedColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$count', style: AppTextStyle.description),
            ),
          ],
        ),
      ),
    );
  }
}
