import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AccountTypeEnum {
  imap(1),

  gmailOAuth(2),

  outlookOAuth(3);

  const AccountTypeEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
