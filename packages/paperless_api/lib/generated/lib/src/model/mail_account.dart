//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/account_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/imap_security_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'mail_account.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MailAccount {
  /// Returns a new [MailAccount] instance.
  MailAccount({
    required this.id,

    required this.name,

    required this.imapServer,

    this.imapPort,

    this.imapSecurity,

    required this.username,

    required this.password,

    this.characterSet,

    this.isToken,

    this.owner,

    required this.userCanChange,

    this.accountType,

    this.expiration,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'imap_server', required: true, includeIfNull: false)
  final String imapServer;

  /// This is usually 143 for unencrypted and STARTTLS connections, and 993 for SSL connections.
  // minimum: -2147483648
  // maximum: 2147483647
  @JsonKey(name: r'imap_port', required: false, includeIfNull: false)
  final int? imapPort;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'imap_security', required: false, includeIfNull: false)
  final ImapSecurityEnum? imapSecurity;

  @JsonKey(name: r'username', required: true, includeIfNull: false)
  final String username;

  @JsonKey(name: r'password', required: true, includeIfNull: false)
  final String password;

  /// The character set to use when communicating with the mail server, such as 'UTF-8' or 'US-ASCII'.
  @JsonKey(name: r'character_set', required: false, includeIfNull: false)
  final String? characterSet;

  @JsonKey(name: r'is_token', required: false, includeIfNull: false)
  final bool? isToken;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'user_can_change', required: true, includeIfNull: false)
  final bool userCanChange;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'account_type', required: false, includeIfNull: false)
  final AccountTypeEnum? accountType;

  /// The expiration date of the refresh token.
  @JsonKey(name: r'expiration', required: false, includeIfNull: false)
  final DateTime? expiration;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MailAccount &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                name,
                imapServer,
                imapPort,
                imapSecurity,
                username,
                password,
                characterSet,
                isToken,
                owner,
                userCanChange,
                accountType,
                expiration,
              ],
              [
                other.id,
                other.name,
                other.imapServer,
                other.imapPort,
                other.imapSecurity,
                other.username,
                other.password,
                other.characterSet,
                other.isToken,
                other.owner,
                other.userCanChange,
                other.accountType,
                other.expiration,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        name,
        imapServer,
        imapPort,
        imapSecurity,
        username,
        password,
        characterSet,
        isToken,
        owner,
        userCanChange,
        accountType,
        expiration,
      ]);

  factory MailAccount.fromJson(Map<String, dynamic> json) =>
      _$MailAccountFromJson(json);

  Map<String, dynamic> toJson() => _$MailAccountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
