import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_state.dart';

import '../../../mocks.dart';

void main() {
  late MockStackOverthoughtRepository mockRepository;
  late MockLocalDataSource mockLocalDataSource;
  late StackOverthoughtCubit cubit;

  setUp(() {
    mockRepository = MockStackOverthoughtRepository();
    mockLocalDataSource = MockLocalDataSource();

    when(mockLocalDataSource.getAll()).thenReturn([]);

    cubit = StackOverthoughtCubit(mockRepository, mockLocalDataSource);
  });

  group('initial state', () {
    test('loads notes from local datasource', () {
      expect(cubit.state.notes, isNotNull);
    });
  });

  group('getAvailableTags', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'emits availableTags when success',
      build: () {
        when(
          mockRepository.getAvailableTags(),
        ).thenAnswer((_) async => [tagWork, tagPersonal]);
        return cubit;
      },
      act: (cubit) => cubit.getAvailableTags(),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.availableTags,
          'availableTags',
          [tagWork, tagPersonal],
        ),
      ],
    );
  });

  group('select/unselect', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'selectNote',
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
      'unselectNote',
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
      'adds note via datasource',
      build: () {
        when(
          mockLocalDataSource.create(noteWork),
        ).thenAnswer((_) async => [noteWork]);
        return cubit;
      },
      act: (cubit) => cubit.addNote(noteWork),
      expect: () => [
        isA<StackOverthoughtState>()
            .having((s) => s.notes, 'notes', [noteWork])
            .having((s) => s.selectedNote, 'selectedNote', isNull),
      ],
    );
  });

  group('removeNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'removes note',
      build: () {
        when(
          mockLocalDataSource.delete(noteWork.id),
        ).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.removeNote(noteWork),
      expect: () => [
        isA<StackOverthoughtState>()
            .having((s) => s.notes, 'notes', [])
            .having((s) => s.selectedNote, 'selectedNote', isNull),
      ],
    );
  });

  group('editNote', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'updates selected note safely',
      build: () {
        final edited = noteWork.copyWith(content: 'edited');

        when(
          mockLocalDataSource.update(FakeNote()),
        ).thenAnswer((_) async => [edited]);
        return cubit;
      },
      seed: () =>
          cubit.state.copyWith(selectedNote: noteWork, notes: [noteWork]),
      act: (cubit) {
        final newData = noteWork.copyWith(content: 'edited');
        cubit.editNote(newData);
      },
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.notes!.first.content,
          'content',
          'edited',
        ),
      ],
    );
  });

  group('search', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'setSearchQuery',
      build: () => cubit,
      act: (cubit) => cubit.setSearchQuery('work'),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.searchQuery,
          'query',
          'work',
        ),
      ],
    );
  });

  group('tag filter', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'setTagFilter',
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
      'clearTagFilter',
      build: () => cubit,
      seed: () => cubit.state.copyWith(tagFilter: tagWork),
      act: (cubit) => cubit.setTagFilter(null),
      expect: () => [
        isA<StackOverthoughtState>().having(
          (s) => s.tagFilter,
          'tagFilter',
          isNull,
        ),
      ],
    );
  });

  group('filteredNotes', () {
    blocTest<StackOverthoughtCubit, StackOverthoughtState>(
      'filters correctly',
      build: () => cubit,
      seed: () => cubit.state.copyWith(
        notes: [noteWork, notePersonal],
        searchQuery: 'personal',
      ),
      verify: (cubit) {
        expect(cubit.filteredNotes, [notePersonal]);
      },
    );
  });
}
