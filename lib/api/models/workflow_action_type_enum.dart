import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum WorkflowActionTypeEnum {
  assignment(1),
  removal(2),
  email(3),
  webhook(4);

  const WorkflowActionTypeEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
