//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/data_type_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'custom_field_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CustomFieldRequest {
  /// Returns a new [CustomFieldRequest] instance.
  CustomFieldRequest({
    required this.name,

    required this.dataType,

    this.extraData,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'data_type', required: true, includeIfNull: false)
  final DataTypeEnum dataType;

  /// Extra data for the custom field, such as select options
  @JsonKey(name: r'extra_data', required: false, includeIfNull: false)
  final Object? extraData;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomFieldRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [name, dataType, extraData],
              [other.name, other.dataType, other.extraData],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([name, dataType, extraData]);

  factory CustomFieldRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFieldRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
