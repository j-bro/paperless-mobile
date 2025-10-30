//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/workflow_trigger.dart';
import 'package:paperless_api/generated/lib/src/model/workflow_action.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Workflow {
  /// Returns a new [Workflow] instance.
  Workflow({
    required this.id,

    required this.name,

    this.order,

    this.enabled,

    required this.triggers,

    required this.actions,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'order', required: false, includeIfNull: false)
  final int? order;

  @JsonKey(name: r'enabled', required: false, includeIfNull: false)
  final bool? enabled;

  @JsonKey(name: r'triggers', required: true, includeIfNull: false)
  final List<WorkflowTrigger> triggers;

  @JsonKey(name: r'actions', required: true, includeIfNull: false)
  final List<WorkflowAction> actions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Workflow &&
            runtimeType == other.runtimeType &&
            equals(
              [id, name, order, enabled, triggers, actions],
              [
                other.id,
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
      mapPropsToHashCode([id, name, order, enabled, triggers, actions]);

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
