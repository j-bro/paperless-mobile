import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_custom_field_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedCustomFieldRequest {
  final PatchedValue<String?>? name;
  final PatchedValue<DataTypeEnum?>? dataType;

  /// Extra data for the custom field, such as select options
  final PatchedValue<Object?>? extraData;

  PatchedCustomFieldRequest({this.name, this.dataType, this.extraData});

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedCustomFieldRequestToJson(this));
}
