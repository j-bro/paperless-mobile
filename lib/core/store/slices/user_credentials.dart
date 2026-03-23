import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';

part 'user_credentials.g.dart';

@CopyWith()
@JsonSerializable()
class UserCredentials {
  final String token;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;

  UserCredentials({
    required this.token,
    this.clientCertificate,
    this.additionalHeaders,
  });
  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);
  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsFromJson(json);
}
