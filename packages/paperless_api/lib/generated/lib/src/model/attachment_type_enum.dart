//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
enum AttachmentTypeEnum {
  /// * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
  @JsonValue(1)
  number1('1'),

  /// * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
  @JsonValue(2)
  number2('2');

  const AttachmentTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
