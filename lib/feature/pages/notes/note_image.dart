import 'dart:convert';

import 'package:flutter/material.dart';

class NoteImage extends StatelessWidget {
  final String? imageBase64;
  const NoteImage({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    if (imageBase64 == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        base64Decode(imageBase64!),
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
