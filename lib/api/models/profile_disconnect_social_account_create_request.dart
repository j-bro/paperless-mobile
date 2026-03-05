//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'profile_disconnect_social_account_create_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProfileDisconnectSocialAccountCreateRequest {
  /// Returns a new [ProfileDisconnectSocialAccountCreateRequest] instance.
  ProfileDisconnectSocialAccountCreateRequest({required this.id});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProfileDisconnectSocialAccountCreateRequest &&
            runtimeType == other.runtimeType &&
            equals([id], [other.id]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([id]);

  factory ProfileDisconnectSocialAccountCreateRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ProfileDisconnectSocialAccountCreateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileDisconnectSocialAccountCreateRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
