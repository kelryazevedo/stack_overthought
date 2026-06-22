import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/remote_datasource/stack_overthought_default.dart';
import 'package:stack_overthought/repository/remote_datasource/stack_overthought_endpoints.dart';

class StackOverthoughtApi {
  final http.Client client;

  StackOverthoughtApi({http.Client? client}) : client = client ?? http.Client();

  Future<List<Tag>> getAvailableTags() async {
    try {
      final response = await client.get(
        Uri.parse(StackOverthoughtEndpoints.availableTags),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        return data
            .map((e) => Tag.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return _defaultTags();
    } catch (e) {
      debugPrint('error from api: $e');
      return _defaultTags();
    }
  }

  List<Tag> _defaultTags() {
    final data = jsonDecode(defaultTagsJson) as List<dynamic>;
    return data.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
  }
}
