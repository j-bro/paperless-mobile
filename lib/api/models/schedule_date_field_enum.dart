//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
enum ScheduleDateFieldEnum {
  /// * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  @JsonValue(r'added')
  added(r'added'),

  /// * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  @JsonValue(r'created')
  created(r'created'),

  /// * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  @JsonValue(r'modified')
  modified(r'modified'),

  /// * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  @JsonValue(r'custom_field')
  customField(r'custom_field');

  const ScheduleDateFieldEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
