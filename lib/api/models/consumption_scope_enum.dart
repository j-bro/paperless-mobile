import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ConsumptionScopeEnum {
  attachmentsOnly(1),
  fullMailAsEml(2),
  fullMailAsEmlAndSeparateAttachments(3);

  const ConsumptionScopeEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
