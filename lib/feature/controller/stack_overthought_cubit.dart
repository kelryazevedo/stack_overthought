import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/stack_overthought_contract.dart';

class StackOverthoughtCubit extends Cubit<StackOverthoughtState> {
  final StackOverthoughtRepository repository;

  StackOverthoughtCubit(this.repository)
    : super(const StackOverthoughtState()) {
    emit(state.copyWith(notes: mockNotesInitial));
  }

  List<Tag> get availableTags => state.availableTags ?? [];

  List<Tag> get activeTags => availableTags
      .where(
        (tag) => state.notes?.any((note) => note.tag.id == tag.id) ?? false,
      )
      .toList();

  Future<void> getAvailableTags() async {
    try {
      final tags = await repository.getAvailableTags();
      emit(state.copyWith(availableTags: tags));
      debugPrint('available tags successfully');
    } catch (e) {
      debugPrint('Error loading tags: $e');
    }
  }

  void selectNote(Note note) => emit(state.copyWith(selectedNote: note));
  void unselectNote() => emit(state.copyWith(clearSelectedNote: true));

  void addNote(Note note) {
    final updatedNotes = List<Note>.from(state.notes ?? [])..add(note);
    emit(
      state.copyWith(
        notes: updatedNotes,
        clearSelectedNote: true,
        clearPendingImage: true,
        clearTagFilter: true,
      ),
    );
    debugPrint('Note added successfully.');
  }

  void removeNote(Note note) {
    final updatedNotes = List<Note>.from(state.notes ?? [])
      ..removeWhere((n) => n.title == note.title);
    emit(state.copyWith(notes: updatedNotes, clearSelectedNote: true));
    debugPrint('Note removed successfully.');
  }

  void editNote(Note note) {
    final updatedNotes = List<Note>.from(state.notes ?? [])
      ..removeWhere((n) => n.title == note.title)
      ..add(note);

    emit(state.copyWith(notes: updatedNotes, selectedNote: note));
    debugPrint('Note edited successfully.');
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

  final mockNotesInitial = <Note>[
    Note(
      title: 'Reunião Q4 — Estratégia de produto',
      tag: Tag(color: '#4DB6AC', id: 'work', label: 'Work'),
      excerpt:
          'Discutir o roadmap para o próximo trimestre, prioridades de engineering e alinhamento com marketing...',
      content:
          'Pontos chave:\n• Lançamento feature X em Setembro\n• Revisão de métricas de retenção\n• Budget para Q4 a confirmar\n• Onboarding redesign — João lidera',
      date: '10/06/2000',
    ),
    Note(
      title: 'App de meditação — conceito de UI',
      tag: Tag(color: '#EF9F27', id: 'personal', label: 'Personal'),
      excerpt:
          'Paleta de cores minimalista com azul profundo e branco. Animações suaves de respiração...',
      content: 'Notas de design e interações',
      date: '10/06/2000',
    ),
  ];
}
