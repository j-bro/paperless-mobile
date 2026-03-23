import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum TasksViewTypeEnum {
  autoTask,

  scheduledTask,

  manualTask;

  @override
  String toString() => name;
}
