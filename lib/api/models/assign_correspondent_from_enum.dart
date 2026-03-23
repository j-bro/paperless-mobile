import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AssignCorrespondentFromEnum {
  noAssignment(1),
  useMailAddress(2),
  useNameOrMailAddress(3),
  useCorrespondentSelectedBelow(4);

  const AssignCorrespondentFromEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
