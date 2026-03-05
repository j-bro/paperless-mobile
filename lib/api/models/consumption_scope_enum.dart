//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Only process attachments. * `2` - Process full Mail (with embedded attachments in file) as .eml * `3` - Process full Mail (with embedded attachments in file) as .eml + process attachments as separate documents
enum ConsumptionScopeEnum {
  /// * `1` - Only process attachments. * `2` - Process full Mail (with embedded attachments in file) as .eml * `3` - Process full Mail (with embedded attachments in file) as .eml + process attachments as separate documents
  @JsonValue(1)
  number1('1'),

  /// * `1` - Only process attachments. * `2` - Process full Mail (with embedded attachments in file) as .eml * `3` - Process full Mail (with embedded attachments in file) as .eml + process attachments as separate documents
  @JsonValue(2)
  number2('2'),

  /// * `1` - Only process attachments. * `2` - Process full Mail (with embedded attachments in file) as .eml * `3` - Process full Mail (with embedded attachments in file) as .eml + process attachments as separate documents
  @JsonValue(3)
  number3('3');

  const ConsumptionScopeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
