import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/status_enum.dart';
import 'package:paperless_api/generated/lib/src/model/task_name_enum.dart';
import 'package:paperless_api/generated/lib/src/model/tasks_view_type_enum.dart';

part 'task_filter_options.g.dart';

@JsonSerializable(
  checked: true,
  createFactory: false,
  explicitToJson: true,
  includeIfNull: false,
)
class TaskFilterOptions {
  final bool? acknowledged;
  final StatusEnum? status;
  final TaskNameEnum? taskName;
  final TasksViewTypeEnum? type;
  final String? taskId;

  TaskFilterOptions({
    this.acknowledged,
    this.status,
    this.taskName,
    this.type,
    this.taskId,
  });

  Map<String, dynamic> toJson() => _$TaskFilterOptionsToJson(this);
}
