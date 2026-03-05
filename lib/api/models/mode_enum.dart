//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `skip` - skip * `redo` - redo * `force` - force * `skip_noarchive` - skip_noarchive
enum ModeEnum {
  /// * `skip` - skip * `redo` - redo * `force` - force * `skip_noarchive` - skip_noarchive
  @JsonValue(r'skip')
  skip(r'skip'),

  /// * `skip` - skip * `redo` - redo * `force` - force * `skip_noarchive` - skip_noarchive
  @JsonValue(r'redo')
  redo(r'redo'),

  /// * `skip` - skip * `redo` - redo * `force` - force * `skip_noarchive` - skip_noarchive
  @JsonValue(r'force')
  force(r'force'),

  /// * `skip` - skip * `redo` - redo * `force` - force * `skip_noarchive` - skip_noarchive
  @JsonValue(r'skip_noarchive')
  skipNoarchive(r'skip_noarchive');

  const ModeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
