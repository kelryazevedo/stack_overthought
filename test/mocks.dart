import 'package:mockito/mockito.dart';
import 'package:stack_overthought/model/note.dart';
import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/stack_overthought_contract.dart';

class MockStackOverthoughtRepository extends Mock
    implements StackOverthoughtRepository {}

final noteWork = Note(
  title: 'Work note',
  tag: tagWork,
  excerpt: 'work excerpt',
  content: 'work content',
  date: '10/06/2000',
);

final notePersonal = Note(
  title: 'Personal note',
  tag: tagPersonal,
  excerpt: 'personal excerpt',
  content: 'personal content',
  date: '10/06/2000',
);

final tagWork = Tag(id: 'work', label: 'Work', color: '#EF9F27');
final tagPersonal = Tag(id: 'personal', label: 'Personal', color: '#4DB6AC');
final tagIdeas = Tag(id: 'ideas', label: 'Ideas', color: '#7C4DFF');
