//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
enum TasksViewTypeEnum {
  /// * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
  @JsonValue(r'auto_task')
  autoTask(r'auto_task'),

  /// * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
  @JsonValue(r'scheduled_task')
  scheduledTask(r'scheduled_task'),

  /// * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
  @JsonValue(r'manual_task')
  manualTask(r'manual_task');

  const TasksViewTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
