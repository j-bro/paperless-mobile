//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'acknowledge_tasks_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AcknowledgeTasksRequest {
  /// Returns a new [AcknowledgeTasksRequest] instance.
  AcknowledgeTasksRequest({required this.tasks});

  @JsonKey(name: r'tasks', required: true, includeIfNull: false)
  final List<int> tasks;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AcknowledgeTasksRequest &&
            runtimeType == other.runtimeType &&
            equals([tasks], [other.tasks]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([tasks]);

  factory AcknowledgeTasksRequest.fromJson(Map<String, dynamic> json) =>
      _$AcknowledgeTasksRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AcknowledgeTasksRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
