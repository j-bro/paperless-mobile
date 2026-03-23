import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/workflow_action.dart';
import 'package:paperless_mobile/api/models/workflow_trigger.dart';

part 'workflow.freezed.dart';
part 'workflow.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Workflow with _$Workflow {
  factory Workflow({
    required int id,
    required String name,
    int? order,
    bool? enabled,
    required List<WorkflowTrigger> triggers,
    required List<WorkflowAction> actions,
  }) = _Workflow;

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);
}
