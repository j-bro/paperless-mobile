//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:paperless_mobile/api/models/workflow_action_request.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedWorkflowRequest {
  /// Returns a new [PatchedWorkflowRequest] instance.
  PatchedWorkflowRequest({
    this.name,

    this.order,

    this.enabled,

    this.triggers,

    this.actions,
  });

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final Option<String?>? name;

  @JsonKey(name: r'order', required: false, includeIfNull: false)
  final Option<int?>? order;

  @JsonKey(name: r'enabled', required: false, includeIfNull: false)
  final Option<bool?>? enabled;

  @JsonKey(name: r'triggers', required: false, includeIfNull: false)
  final Option<List<WorkflowTriggerRequest>?>? triggers;

  @JsonKey(name: r'actions', required: false, includeIfNull: false)
  final Option<List<WorkflowActionRequest>?>? actions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedWorkflowRequest &&
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

  factory PatchedWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedWorkflowRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedWorkflowRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
