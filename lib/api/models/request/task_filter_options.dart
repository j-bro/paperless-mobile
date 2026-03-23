import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/api/models/status_enum.dart';
import 'package:paperless_mobile/api/models/task_name_enum.dart';
import 'package:paperless_mobile/api/models/tasks_view_type_enum.dart';

part 'task_filter_options.g.dart';

@CopyWith()
@JsonSerializable(createFactory: false, includeIfNull: false)
class TaskFilterOptions with EquatableMixin {
  final bool? acknowledged;
  final StatusEnum? status;
  final TaskNameEnum? taskName;
  final TasksViewTypeEnum? type;
  final String? ordering;

  const TaskFilterOptions({
    this.acknowledged,
    this.status,
    this.taskName,
    this.type,
    this.ordering,
  });

  Map<String, dynamic> toJson() => _$TaskFilterOptionsToJson(this);

  @override
  List<Object?> get props => [acknowledged, status, taskName, type, ordering];
}
