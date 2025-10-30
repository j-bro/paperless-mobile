//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'patched_profile_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedProfileRequest {
  /// Returns a new [PatchedProfileRequest] instance.
  PatchedProfileRequest({
    this.email,

    this.password,

    this.firstName,

    this.lastName,
  });

  @JsonKey(name: r'email', required: false, includeIfNull: false)
  final String? email;

  @JsonKey(name: r'password', required: false, includeIfNull: false)
  final String? password;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedProfileRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [email, password, firstName, lastName],
              [other.email, other.password, other.firstName, other.lastName],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([email, password, firstName, lastName]);

  factory PatchedProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PatchedProfileRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
