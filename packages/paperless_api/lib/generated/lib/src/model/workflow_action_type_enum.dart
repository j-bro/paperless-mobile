//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `1` - Assignment * `2` - Removal * `3` - Email * `4` - Webhook
enum WorkflowActionTypeEnum {
  /// * `1` - Assignment * `2` - Removal * `3` - Email * `4` - Webhook
  @JsonValue(1)
  number1('1'),

  /// * `1` - Assignment * `2` - Removal * `3` - Email * `4` - Webhook
  @JsonValue(2)
  number2('2'),

  /// * `1` - Assignment * `2` - Removal * `3` - Email * `4` - Webhook
  @JsonValue(3)
  number3('3'),

  /// * `1` - Assignment * `2` - Removal * `3` - Email * `4` - Webhook
  @JsonValue(4)
  number4('4');

  const WorkflowActionTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
