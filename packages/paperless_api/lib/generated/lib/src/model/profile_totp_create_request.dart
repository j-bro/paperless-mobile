//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'profile_totp_create_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProfileTotpCreateRequest {
  /// Returns a new [ProfileTotpCreateRequest] instance.
  ProfileTotpCreateRequest({required this.secret, required this.code});

  @JsonKey(name: r'secret', required: true, includeIfNull: false)
  final String secret;

  @JsonKey(name: r'code', required: true, includeIfNull: false)
  final String code;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProfileTotpCreateRequest &&
            runtimeType == other.runtimeType &&
            equals([secret, code], [other.secret, other.code]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([secret, code]);

  factory ProfileTotpCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileTotpCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileTotpCreateRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
