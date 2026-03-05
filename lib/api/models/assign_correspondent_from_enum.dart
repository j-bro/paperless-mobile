//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Do not assign a correspondent * `2` - Use mail address * `3` - Use name (or mail address if not available) * `4` - Use correspondent selected below
enum AssignCorrespondentFromEnum {
  /// * `1` - Do not assign a correspondent * `2` - Use mail address * `3` - Use name (or mail address if not available) * `4` - Use correspondent selected below
  @JsonValue(1)
  number1('1'),

  /// * `1` - Do not assign a correspondent * `2` - Use mail address * `3` - Use name (or mail address if not available) * `4` - Use correspondent selected below
  @JsonValue(2)
  number2('2'),

  /// * `1` - Do not assign a correspondent * `2` - Use mail address * `3` - Use name (or mail address if not available) * `4` - Use correspondent selected below
  @JsonValue(3)
  number3('3'),

  /// * `1` - Do not assign a correspondent * `2` - Use mail address * `3` - Use name (or mail address if not available) * `4` - Use correspondent selected below
  @JsonValue(4)
  number4('4');

  const AssignCorrespondentFromEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
