import 'package:freezed_annotation/freezed_annotation.dart';

part 'acknowledge_tasks.freezed.dart';
part 'acknowledge_tasks.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class AcknowledgeTasks with _$AcknowledgeTasks {
  factory AcknowledgeTasks({int? result}) = _AcknowledgeTasks;

  factory AcknowledgeTasks.fromJson(Map<String, dynamic> json) =>
      _$AcknowledgeTasksFromJson(json);
}
