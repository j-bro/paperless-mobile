import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum AttachmentTypeEnum {
  attachmentsOnly(1),
  all(2);

  const AttachmentTypeEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
