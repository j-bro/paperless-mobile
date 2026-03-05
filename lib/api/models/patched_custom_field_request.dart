//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_custom_field_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedCustomFieldRequest {
  /// Returns a new [PatchedCustomFieldRequest] instance.
  PatchedCustomFieldRequest({this.name, this.dataType, this.extraData});

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final Option<String?>? name;

  @JsonKey(name: r'data_type', required: false, includeIfNull: false)
  final Option<DataTypeEnum?>? dataType;

  /// Extra data for the custom field, such as select options
  @JsonKey(name: r'extra_data', required: false, includeIfNull: false)
  final Option<Object?>? extraData;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedCustomFieldRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [name, dataType, extraData],
              [other.name, other.dataType, other.extraData],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([name, dataType, extraData]);

  factory PatchedCustomFieldRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedCustomFieldRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedCustomFieldRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
