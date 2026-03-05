//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
enum MailRuleActionEnum {
  /// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
  @JsonValue(1)
  number1('1'),

  /// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
  @JsonValue(2)
  number2('2'),

  /// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
  @JsonValue(3)
  number3('3'),

  /// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
  @JsonValue(4)
  number4('4'),

  /// * `1` - Delete * `2` - Move to specified folder * `3` - Mark as read, don't process read mails * `4` - Flag the mail, don't process flagged mails * `5` - Tag the mail with specified tag, don't process tagged mails
  @JsonValue(5)
  number5('5');

  const MailRuleActionEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
