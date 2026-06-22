import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/repository/local_datasource/local_data_source_contract.dart';

class NotesLocalDataSourceRepository implements LocalDataSourceContract {
  final Box<Map> box;

  NotesLocalDataSourceRepository(this.box);

  @override
  Future<List<Note>?> create(Note note) async {
    try {
      await box.put(note.id, note.toJson());
      return getAll();
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  @override
  List<Note>? getAll() {
    try {
      return box.values.map((map) {
        final normalized = normalize(map) as Map<String, dynamic>;
        return Note.fromJson(normalized);
      }).toList();
    } catch (error) {
      debugPrint('Error to getll notes: $error');
      return [];
    }
  }

  @override
  Future<List<Note>?> update(Note note) async {
    try {
      if (!box.containsKey(note.id)) {
        debugPrint('The note does not exist, it cannot be updated.');
        return getAll();
      }

      await box.put(note.id, note.toJson());
      return getAll();
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  @override
  Future<List<Note>?> delete(String id) async {
    try {
      await box.delete(id);
      return getAll();
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }

  dynamic normalize(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(e.key.toString(), normalize(e.value)),
        ),
      );
    } else if (value is List) {
      return value.map(normalize).toList();
    } else {
      return value;
    }
  }
}
