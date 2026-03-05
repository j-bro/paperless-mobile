//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - No encryption * `2` - Use SSL * `3` - Use STARTTLS
enum ImapSecurityEnum {
  /// * `1` - No encryption * `2` - Use SSL * `3` - Use STARTTLS
  @JsonValue(1)
  number1('1'),

  /// * `1` - No encryption * `2` - Use SSL * `3` - Use STARTTLS
  @JsonValue(2)
  number2('2'),

  /// * `1` - No encryption * `2` - Use SSL * `3` - Use STARTTLS
  @JsonValue(3)
  number3('3');

  const ImapSecurityEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
