import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AssignTitleFromEnum {
  subject(1),
  attachmentFilename(2),
  doNotAssign(3);

  const AssignTitleFromEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
