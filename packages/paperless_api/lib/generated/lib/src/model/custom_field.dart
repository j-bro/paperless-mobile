//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/data_type_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'custom_field.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CustomField {
  /// Returns a new [CustomField] instance.
  CustomField({
    required this.id,

    required this.name,

    required this.dataType,

    this.extraData,

    required this.documentCount,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'data_type', required: true, includeIfNull: false)
  final DataTypeEnum dataType;

  /// Extra data for the custom field, such as select options
  @JsonKey(name: r'extra_data', required: false, includeIfNull: false)
  final Object? extraData;

  @JsonKey(name: r'document_count', required: true, includeIfNull: false)
  final int documentCount;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomField &&
            runtimeType == other.runtimeType &&
            equals(
              [id, name, dataType, extraData, documentCount],
              [
                other.id,
                other.name,
                other.dataType,
                other.extraData,
                other.documentCount,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([id, name, dataType, extraData, documentCount]);

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFieldToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
