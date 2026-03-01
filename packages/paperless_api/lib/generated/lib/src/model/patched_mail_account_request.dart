//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:paperless_api/generated/lib/src/model/account_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/imap_security_enum.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_api/src/utils/patched_value.dart';

part 'patched_mail_account_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedMailAccountRequest {
  /// Returns a new [PatchedMailAccountRequest] instance.
  PatchedMailAccountRequest({
    this.name,

    this.imapServer,

    this.imapPort,

    this.imapSecurity,

    this.username,

    this.password,

    this.characterSet,

    this.isToken,

    this.owner,

    this.setPermissions,

    this.accountType,

    this.expiration,
  });

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final Option<String?>? name;

  @JsonKey(name: r'imap_server', required: false, includeIfNull: false)
  final Option<String?>? imapServer;

  /// This is usually 143 for unencrypted and STARTTLS connections, and 993 for SSL connections.
  // minimum: -2147483648
  // maximum: 2147483647
  @JsonKey(name: r'imap_port', required: false, includeIfNull: false)
  final Option<int?>? imapPort;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'imap_security', required: false, includeIfNull: false)
  final Option<ImapSecurityEnum?>? imapSecurity;

  @JsonKey(name: r'username', required: false, includeIfNull: false)
  final Option<String?>? username;

  @JsonKey(name: r'password', required: false, includeIfNull: false)
  final Option<String?>? password;

  /// The character set to use when communicating with the mail server, such as 'UTF-8' or 'US-ASCII'.
  @JsonKey(name: r'character_set', required: false, includeIfNull: false)
  final Option<String?>? characterSet;

  @JsonKey(name: r'is_token', required: false, includeIfNull: false)
  final Option<bool?>? isToken;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final Option<int?>? owner;

  @JsonKey(name: r'set_permissions', required: false, includeIfNull: false)
  final Option<CorrespondentRequestSetPermissions?>? setPermissions;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'account_type', required: false, includeIfNull: false)
  final Option<AccountTypeEnum?>? accountType;

  /// The expiration date of the refresh token.
  @JsonKey(name: r'expiration', required: false, includeIfNull: false)
  final Option<DateTime?>? expiration;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedMailAccountRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                name,
                imapServer,
                imapPort,
                imapSecurity,
                username,
                password,
                characterSet,
                isToken,
                owner,
                setPermissions,
                accountType,
                expiration,
              ],
              [
                other.name,
                other.imapServer,
                other.imapPort,
                other.imapSecurity,
                other.username,
                other.password,
                other.characterSet,
                other.isToken,
                other.owner,
                other.setPermissions,
                other.accountType,
                other.expiration,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        name,
        imapServer,
        imapPort,
        imapSecurity,
        username,
        password,
        characterSet,
        isToken,
        owner,
        setPermissions,
        accountType,
        expiration,
      ]);

  factory PatchedMailAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedMailAccountRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedMailAccountRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
