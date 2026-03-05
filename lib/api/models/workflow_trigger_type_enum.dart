//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Consumption Started * `2` - Document Added * `3` - Document Updated * `4` - Scheduled
enum WorkflowTriggerTypeEnum {
  /// * `1` - Consumption Started * `2` - Document Added * `3` - Document Updated * `4` - Scheduled
  @JsonValue(1)
  number1('1'),

  /// * `1` - Consumption Started * `2` - Document Added * `3` - Document Updated * `4` - Scheduled
  @JsonValue(2)
  number2('2'),

  /// * `1` - Consumption Started * `2` - Document Added * `3` - Document Updated * `4` - Scheduled
  @JsonValue(3)
  number3('3'),

  /// * `1` - Consumption Started * `2` - Document Added * `3` - Document Updated * `4` - Scheduled
  @JsonValue(4)
  number4('4');

  const WorkflowTriggerTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
