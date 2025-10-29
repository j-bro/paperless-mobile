//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - IMAP * `2` - Gmail OAuth * `3` - Outlook OAuth
enum AccountTypeEnum {
  /// * `1` - IMAP * `2` - Gmail OAuth * `3` - Outlook OAuth
  @JsonValue(1)
  number1('1'),

  /// * `1` - IMAP * `2` - Gmail OAuth * `3` - Outlook OAuth
  @JsonValue(2)
  number2('2'),

  /// * `1` - IMAP * `2` - Gmail OAuth * `3` - Outlook OAuth
  @JsonValue(3)
  number3('3');

  const AccountTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
