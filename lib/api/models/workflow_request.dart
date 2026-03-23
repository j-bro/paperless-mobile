import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/workflow_action_request.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_request.dart';

part 'workflow_request.freezed.dart';
part 'workflow_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class WorkflowRequest with _$WorkflowRequest {
  factory WorkflowRequest({
    required String name,
    int? order,
    bool? enabled,
    required List<WorkflowTriggerRequest> triggers,
    required List<WorkflowActionRequest> actions,
  }) = _WorkflowRequest;
}
