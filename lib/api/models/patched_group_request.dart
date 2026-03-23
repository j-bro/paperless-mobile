import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_group_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedGroupRequest {
  final PatchedValue<String?>? name;
  final PatchedValue<List<String>?>? permissions;

  PatchedGroupRequest({this.name, this.permissions});

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedGroupRequestToJson(this));
}
