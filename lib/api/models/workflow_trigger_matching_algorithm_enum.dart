import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum WorkflowTriggerMatchingAlgorithmEnum {
  none(0),
  anyWord(1),
  allWords(2),
  exactMatch(3),
  regularExpression(4),
  fuzzyWord(5);

  const WorkflowTriggerMatchingAlgorithmEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
