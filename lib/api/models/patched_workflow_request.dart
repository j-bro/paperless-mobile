import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/workflow_action_request.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedWorkflowRequest {
  final PatchedValue<String?>? name;
  final PatchedValue<int?>? order;
  final PatchedValue<bool?>? enabled;
  final PatchedValue<List<WorkflowTriggerRequest>?>? triggers;
  final PatchedValue<List<WorkflowActionRequest>?>? actions;

  PatchedWorkflowRequest({
    this.name,
    this.order,
    this.enabled,
    this.triggers,
    this.actions,
  });

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedWorkflowRequestToJson(this));
}
