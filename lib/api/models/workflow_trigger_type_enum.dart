import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum WorkflowTriggerTypeEnum {
  consumptionStarted(1),
  documentAdded(2),
  documentUpdated(3),
  scheduled(4);

  const WorkflowTriggerTypeEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
