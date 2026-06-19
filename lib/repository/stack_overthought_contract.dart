import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/api/stack_overthought_api.dart';

class StackOverthoughtRepository {
  final StackOverthoughtApi api;

  StackOverthoughtRepository(this.api);

  Future<List<Tag>>? getAvailableTags() => api.getAvailableTags();
}
