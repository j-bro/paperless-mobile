//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'custom_field_instance.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CustomFieldInstance {
  /// Returns a new [CustomFieldInstance] instance.
  CustomFieldInstance({required this.value, required this.field});

  /// Given the *incoming* primitive data, return the value for this field that should be validated and transformed to a native value.
  @JsonKey(name: r'value', required: true, includeIfNull: true)
  final Object? value;

  @JsonKey(name: r'field', required: true, includeIfNull: false)
  final int field;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomFieldInstance &&
            runtimeType == other.runtimeType &&
            equals([value, field], [other.value, other.field]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([value, field]);

  factory CustomFieldInstance.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFieldInstanceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
