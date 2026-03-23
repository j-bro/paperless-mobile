import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ImapSecurityEnum {
  noEncryption(1),
  useSSL(2),
  useSTARTTLS(3);

  const ImapSecurityEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
