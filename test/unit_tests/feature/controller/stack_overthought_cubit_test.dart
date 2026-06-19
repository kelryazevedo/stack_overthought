import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';

import '../../../mocks.dart';

void main() {
  late MockStackOverthoughtRepository mockRepository;
  late StackOverthoughtCubit cubit;

  setUp(() {
    mockRepository = MockStackOverthoughtRepository();
    cubit = StackOverthoughtCubit(mockRepository);
  });

  test('initial state contains the mocked notes (mockNotesInitial)', () {
    expect(cubit.state.notes, isNotNull);
    expect(cubit.state.notes!.length, cubit.mockNotesInitial.length);
  });

  group('getAvailableTags', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'emits availableTags when the repository call succeeds',
      build: () {
        when(
          mockRepository.getAvailableTags(),
        ).thenAnswer((_) async => [tagWork, tagPersonal, tagIdeas]);
        return cubit;
      },
      act: (cubit) => cubit.getAvailableTags(),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.availableTags,
          'availableTags',
          [tagWork, tagPersonal, tagIdeas],
        ),
      ],
      verify: (_) => verify(mockRepository.getAvailableTags()).called(1),
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'does not emit a new state when the repository throws',
      build: () {
        when(
          mockRepository.getAvailableTags(),
        ).thenThrow(Exception('network failure'));
        return cubit;
      },
      act: (cubit) => cubit.getAvailableTags(),
      verify: (_) => verify(mockRepository.getAvailableTags()).called(1),
    );
  });

  group('availableTags / activeTags getters', () {
    test('availableTags returns [] when state.availableTags is null', () {
      expect(cubit.availableTags, isEmpty);
    });

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'activeTags returns only tags present in the current notes',
      build: () {
        when(
          mockRepository.getAvailableTags(),
        ).thenAnswer((_) async => [tagWork, tagPersonal, tagIdeas]);
        return cubit;
      },
      act: (cubit) async {
        await cubit.getAvailableTags();
        cubit.addNote(noteWork);
      },
      verify: (cubit) {
        expect(cubit.activeTags, contains(tagWork));
        expect(cubit.activeTags, isNot(contains(tagIdeas)));
      },
    );
  });

  group('selectNote / unselectNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'selectNote emits the selected note',
      build: () => cubit,
      act: (cubit) => cubit.selectNote(noteWork),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.selectedNote,
          'selectedNote',
          noteWork,
        ),
      ],
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'unselectNote clears the selected note',
      build: () => cubit,
      seed: () => cubit.state.copyWith(selectedNote: noteWork),
      act: (cubit) => cubit.unselectNote(),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.selectedNote,
          'selectedNote',
          isNull,
        ),
      ],
    );
  });

  group('addNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'adds the note to the list and clears selected note, pending image '
      'and tag filter',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        selectedNote: notePersonal,
        loadingImage: 'image.png',
        tagFilter: tagPersonal,
      ),
      act: (cubit) => cubit.addNote(noteWork),
      expect: () => [
        isA<StackOverthoughtState>()
            .having((s) => s.notes, 'notes', contains(noteWork))
            .having((s) => s.selectedNote, 'selectedNote', isNull)
            .having((s) => s.loadingImage, 'loadingImage', isNull)
            .having((s) => s.tagFilter, 'tagFilter', isNull),
      ],
    );
  });

  group('removeNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'removes the note by title and clears the selected note',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        notes: [noteWork, notePersonal],
        selectedNote: noteWork,
      ),
      act: (cubit) => cubit.removeNote(noteWork),
      expect: () => [
        isA<StackOverthoughtState>()
            .having(
              (s) => s.notes,
              'notes',
              everyElement(isNot(equals(noteWork))),
            )
            .having((s) => s.selectedNote, 'selectedNote', isNull),
      ],
    );
  });

  group('editNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'replaces the note with the same title and marks it as selected',
      build: () => cubit,
      seed: () => cubit.state.copyWith(notes: [noteWork]),
      act: (cubit) {
        final edited = noteWork.copyWith(content: 'edited content');
        cubit.editNote(edited);
      },
      verify: (cubit) {
        expect(cubit.state.notes!.length, 1);
        expect(cubit.state.notes!.first.content, 'edited content');
        expect(cubit.state.selectedNote?.content, 'edited content');
      },
    );
  });

  group('setSearchQuery', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'emits the state with the updated query',
      build: () => cubit,
      act: (cubit) => cubit.setSearchQuery('meeting'),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.searchQuery,
          'searchQuery',
          'meeting',
        ),
      ],
    );
  });

  group('setTagFilter', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'sets the filter when a tag is passed',
      build: () => cubit,
      act: (cubit) => cubit.setTagFilter(tagWork),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.tagFilter,
          'tagFilter',
          tagWork,
        ),
      ],
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'clears the filter and the selected note when null is passed',
      build: () => cubit,
      seed: () =>
          cubit.state.copyWith(tagFilter: tagWork, selectedNote: noteWork),
      act: (cubit) => cubit.setTagFilter(null),
      expect: () => [
        isA<StackOverthoughtState>()
            .having((s) => s.tagFilter, 'tagFilter', isNull)
            .having((s) => s.selectedNote, 'selectedNote', isNull),
      ],
    );
  });

  group('setLoadingImage', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'sets the pending image when a value is passed',
      build: () => cubit,
      act: (cubit) => cubit.setLoadingImage('photo.png'),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.loadingImage,
          'loadingImage',
          'photo.png',
        ),
      ],
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'clears the pending image when null is passed',
      build: () => cubit,
      seed: () => cubit.state.copyWith(loadingImage: 'photo.png'),
      act: (cubit) => cubit.setLoadingImage(null),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.loadingImage,
          'loadingImage',
          isNull,
        ),
      ],
    );
  });

  group('filteredNotes', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'filters by search text (title, excerpt or content)',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        notes: [noteWork, notePersonal],
        searchQuery: 'personal',
      ),
      verify: (cubit) => expect(cubit.filteredNotes, [notePersonal]),
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'filters by the selected tag',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        notes: [noteWork, notePersonal],
        tagFilter: tagWork,
      ),
      verify: (cubit) => expect(cubit.filteredNotes, [noteWork]),
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'returns all notes when there is no search query or tag filter',
      build: () => cubit,
      seed: () => cubit.state.copyWith(notes: [noteWork, notePersonal]),
      verify: (cubit) => expect(cubit.filteredNotes, [noteWork, notePersonal]),
    );

    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'combines search query and tag filter at the same time',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        notes: [noteWork, notePersonal],
        searchQuery: 'note',
        tagFilter: tagPersonal,
      ),
      verify: (cubit) => expect(cubit.filteredNotes, [notePersonal]),
    );
  });
}
