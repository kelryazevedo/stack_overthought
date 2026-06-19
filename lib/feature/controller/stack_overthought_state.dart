import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';

class StackOverthoughtState {
  const StackOverthoughtState({
    this.notes,
    this.selectedNote,
    this.searchQuery = '',
    this.tagFilter,
    this.loadingImage,
    this.availableTags,
  });

  final List<Note>? notes;
  final Note? selectedNote;
  final String searchQuery;
  final Tag? tagFilter;
  final String? loadingImage;
  final List<Tag>? availableTags;

  StackOverthoughtState copyWith({
    List<Note>? notes,
    Note? selectedNote,
    String? searchQuery,
    Tag? tagFilter,
    List<Tag>? availableTags,
    String? loadingImage,
    bool clearTagFilter = false,
    bool clearSelectedNote = false,
    bool clearPendingImage = false,
  }) {
    return StackOverthoughtState(
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      tagFilter: clearTagFilter ? null : (tagFilter ?? this.tagFilter),
      availableTags: availableTags ?? this.availableTags,
      selectedNote: clearSelectedNote
          ? null
          : (selectedNote ?? this.selectedNote),
      loadingImage: clearPendingImage
          ? null
          : (loadingImage ?? this.loadingImage),
    );
  }

  List<Object?> get props => [
    notes,
    selectedNote,
    searchQuery,
    tagFilter,
    availableTags,
  ];
}
