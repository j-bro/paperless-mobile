//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'custom_field_instance_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CustomFieldInstanceRequest {
  /// Returns a new [CustomFieldInstanceRequest] instance.
  CustomFieldInstanceRequest({required this.value, required this.field});

  /// Given the *incoming* primitive data, return the value for this field that should be validated and transformed to a native value.
  @JsonKey(name: r'value', required: true, includeIfNull: true)
  final Object? value;

  @JsonKey(name: r'field', required: true, includeIfNull: false)
  final int field;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomFieldInstanceRequest &&
            runtimeType == other.runtimeType &&
            equals([value, field], [other.value, other.field]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([value, field]);

  factory CustomFieldInstanceRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldInstanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFieldInstanceRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
