import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/local_datasource/local_data_source_contract.dart';
import 'package:stack_overthought/repository/stack_overthought_contract.dart';

class StackOverthoughtCubit extends Cubit<StackOverthoughtState> {
  final StackOverthoughtContracts stackOverthoughtContracts;
  final LocalDataSourceContract localDataSourceContract;

  StackOverthoughtCubit(
    this.stackOverthoughtContracts,
    this.localDataSourceContract,
  ) : super(const StackOverthoughtState()) {
    getAvailableTags();
    emit(state.copyWith(notes: localDataSourceContract.getAll()));
  }

  List<Tag> get availableTags => state.availableTags ?? [];

  List<Tag> get activeTags => availableTags
      .where(
        (tag) => state.notes?.any((note) => note.tag.id == tag.id) ?? false,
      )
      .toList();

  Future<void> getAvailableTags() async {
    try {
      final tags = await stackOverthoughtContracts.getAvailableTags();
      emit(state.copyWith(availableTags: tags));
      debugPrint('available tags successfully');
    } catch (e) {
      debugPrint('Error loading tags: $e');
    }
  }

  void selectNote(Note note) => emit(state.copyWith(selectedNote: note));
  void unselectNote() => emit(state.copyWith(clearSelectedNote: true));

  Future<void> addNote(Note note) async {
    final updatedList = await localDataSourceContract.create(note);
    emit(
      state.copyWith(
        notes: updatedList,
        clearSelectedNote: true,
        clearPendingImage: true,
        clearTagFilter: true,
      ),
    );
    debugPrint('Note added successfully.');
  }

  Future<void> removeNote(Note note) async {
    final updatedList = await localDataSourceContract.delete(note.id);
    emit(state.copyWith(notes: updatedList, clearSelectedNote: true));
    debugPrint('Note removed successfully.');
  }

  Future<void> editNote(Note newData) async {
    final current = state.selectedNote;

    if (current == null) {
      debugPrint('The note does not exist; it cannot be updated.');
      return;
    }

    final updated = current.copyWith(
      title: newData.title,
      content: newData.content,
      excerpt: newData.excerpt,
      tag: newData.tag,
      date: newData.date,
      image: newData.image,
    );
    final updatedList = await localDataSourceContract.update(updated);

    emit(state.copyWith(notes: updatedList, selectedNote: newData));
    debugPrint('Note edited safely');
  }

  void setSearchQuery(String query) => emit(state.copyWith(searchQuery: query));

  void setTagFilter(Tag? tag) {
    if (tag == null) {
      emit(state.copyWith(clearTagFilter: true, clearSelectedNote: true));
    } else {
      emit(state.copyWith(tagFilter: tag));
    }
  }

  void setLoadingImage(String? image) {
    if (image == null) {
      emit(state.copyWith(clearPendingImage: true));
    } else {
      emit(state.copyWith(loadingImage: image));
    }
  }

  List<Note> get filteredNotes {
    final all = state.notes ?? [];
    final q = state.searchQuery.trim().toLowerCase();
    final tag = state.tagFilter;

    return all.where((n) {
      final matchesQuery =
          q.isEmpty ||
          n.title.toLowerCase().contains(q) ||
          n.excerpt.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);

      final matchesTag = tag == null || n.tag.id == tag.id;

      return matchesQuery && matchesTag;
    }).toList();
  }
}
