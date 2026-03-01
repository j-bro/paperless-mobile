//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_api/src/utils/patched_value.dart';

part 'patched_group_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedGroupRequest {
  /// Returns a new [PatchedGroupRequest] instance.
  PatchedGroupRequest({this.name, this.permissions});

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final Option<String?>? name;

  @JsonKey(name: r'permissions', required: false, includeIfNull: false)
  final Option<List<String>?>? permissions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedGroupRequest &&
            runtimeType == other.runtimeType &&
            equals([name, permissions], [other.name, other.permissions]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([name, permissions]);

  factory PatchedGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedGroupRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedGroupRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
