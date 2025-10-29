//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/social_account.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'profile.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Profile {
  /// Returns a new [Profile] instance.
  Profile({
    this.email,

    this.password,

    this.firstName,

    this.lastName,

    required this.authToken,

    required this.socialAccounts,

    required this.hasUsablePassword,

    required this.isMfaEnabled,
  });

  @JsonKey(name: r'email', required: false, includeIfNull: false)
  final String? email;

  @JsonKey(name: r'password', required: false, includeIfNull: false)
  final String? password;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @JsonKey(name: r'auth_token', required: true, includeIfNull: false)
  final String authToken;

  @JsonKey(name: r'social_accounts', required: true, includeIfNull: false)
  final List<SocialAccount> socialAccounts;

  @JsonKey(name: r'has_usable_password', required: true, includeIfNull: false)
  final bool hasUsablePassword;

  @JsonKey(name: r'is_mfa_enabled', required: true, includeIfNull: false)
  final bool isMfaEnabled;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Profile &&
            runtimeType == other.runtimeType &&
            equals(
              [
                email,
                password,
                firstName,
                lastName,
                authToken,
                socialAccounts,
                hasUsablePassword,
                isMfaEnabled,
              ],
              [
                other.email,
                other.password,
                other.firstName,
                other.lastName,
                other.authToken,
                other.socialAccounts,
                other.hasUsablePassword,
                other.isMfaEnabled,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        email,
        password,
        firstName,
        lastName,
        authToken,
        socialAccounts,
        hasUsablePassword,
        isMfaEnabled,
      ]);

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
