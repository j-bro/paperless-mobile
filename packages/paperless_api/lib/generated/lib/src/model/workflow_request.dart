//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/workflow_action_request.dart';
import 'package:paperless_api/generated/lib/src/model/workflow_trigger_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowRequest {
  /// Returns a new [WorkflowRequest] instance.
  WorkflowRequest({
    required this.name,

    this.order,

    this.enabled,

    required this.triggers,

    required this.actions,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'order', required: false, includeIfNull: false)
  final int? order;

  @JsonKey(name: r'enabled', required: false, includeIfNull: false)
  final bool? enabled;

  @JsonKey(name: r'triggers', required: true, includeIfNull: false)
  final List<WorkflowTriggerRequest> triggers;

  @JsonKey(name: r'actions', required: true, includeIfNull: false)
  final List<WorkflowActionRequest> actions;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkflowRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [name, order, enabled, triggers, actions],
              [
                other.name,
                other.order,
                other.enabled,
                other.triggers,
                other.actions,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([name, order, enabled, triggers, actions]);

  factory WorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkflowRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
