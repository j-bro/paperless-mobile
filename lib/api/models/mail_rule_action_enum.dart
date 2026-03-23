import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum MailRuleActionEnum {
  delete(1),
  moveToFolder(2),
  markAsRead(3),
  flagMail(4),
  tagMail(5);

  const MailRuleActionEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
