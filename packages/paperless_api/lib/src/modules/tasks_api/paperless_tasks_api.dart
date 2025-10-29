import 'package:paperless_api/generated/lib/src/model/tasks_view.dart';
import 'package:paperless_api/src/models/request/task_filter_options.dart';

abstract class PaperlessTasksApi {
  Future<TasksView?> find(int id);
  Future<Iterable<TasksView>> findAll([TaskFilterOptions? options]);
  Stream<TasksView> listenForTaskChanges(String taskId);
  Future<void> acknowledgeTasks(Iterable<int> tasks);
}
