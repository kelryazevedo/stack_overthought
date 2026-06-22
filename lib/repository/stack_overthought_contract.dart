import 'package:stack_overthought/model/tag.dart';
import 'package:stack_overthought/repository/remote_datasource/stack_overthought_api.dart';

class StackOverthoughtContracts {
  final StackOverthoughtApi api;
  StackOverthoughtContracts(this.api);
  Future<List<Tag>>? getAvailableTags() => api.getAvailableTags();
}
