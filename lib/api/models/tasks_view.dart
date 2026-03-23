import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/status_enum.dart';
import 'package:paperless_mobile/api/models/task_name_enum.dart';
import 'package:paperless_mobile/api/models/tasks_view_type_enum.dart';

part 'tasks_view.freezed.dart';
part 'tasks_view.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class TasksView with _$TasksView {
  factory TasksView({
    required int id,

    /// Celery ID for the Task that was run
    required String taskId,
    TaskNameEnum? taskName,

    /// Name of the file which the Task was run for
    String? taskFileName,

    /// Datetime field when the task result was created in UTC
    DateTime? dateCreated,

    /// Datetime field when the task was completed in UTC
    DateTime? dateDone,

    /// The type of task that was run  * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
    TasksViewTypeEnum? type,

    /// Current state of the task being run  * `FAILURE` - FAILURE * `PENDING` - PENDING * `RECEIVED` - RECEIVED * `RETRY` - RETRY * `REVOKED` - REVOKED * `STARTED` - STARTED * `SUCCESS` - SUCCESS
    StatusEnum? status,

    /// The data returned by the task
    String? result,

    /// If the task is acknowledged via the frontend or API
    bool? acknowledged,
    String? relatedDocument,
    int? owner,
  }) = _TasksView;

  factory TasksView.fromJson(Map<String, dynamic> json) =>
      _$TasksViewFromJson(json);
}
