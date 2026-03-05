//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'group_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GroupRequest {
  /// Returns a new [GroupRequest] instance.
  GroupRequest({required this.name, required this.permissions});

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'permissions', required: true, includeIfNull: false)
  final List<String> permissions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GroupRequest &&
            runtimeType == other.runtimeType &&
            equals([name, permissions], [other.name, other.permissions]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([name, permissions]);

  factory GroupRequest.fromJson(Map<String, dynamic> json) =>
      _$GroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GroupRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
