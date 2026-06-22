import 'package:stack_overthought/model/note.dart';

abstract class LocalDataSourceContract {
  Future<List<Note>?> create(Note note);
  List<Note>? getAll();
  Future<List<Note>?> update(Note note);
  Future<List<Note>?> delete(String id);
}
