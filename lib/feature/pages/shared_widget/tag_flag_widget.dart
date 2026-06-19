import 'package:flutter/material.dart';
import 'package:stack_overthought/core/ui_core/app_extension.dart';
import 'package:stack_overthought/model/tag.dart';

class TagFlagWidget extends StatelessWidget {
  final Tag tag;

  const TagFlagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.parsedColor.withAlpha(16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag.label,
        style: TextStyle(color: tag.parsedColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}
