//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'acknowledge_tasks.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AcknowledgeTasks {
  /// Returns a new [AcknowledgeTasks] instance.
  AcknowledgeTasks({required this.result});

  @JsonKey(name: r'result', required: true, includeIfNull: false)
  final int result;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AcknowledgeTasks &&
            runtimeType == other.runtimeType &&
            equals([result], [other.result]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([result]);

  factory AcknowledgeTasks.fromJson(Map<String, dynamic> json) =>
      _$AcknowledgeTasksFromJson(json);

  Map<String, dynamic> toJson() => _$AcknowledgeTasksToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
