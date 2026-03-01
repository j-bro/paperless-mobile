import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';

part 'user_credentials.freezed.dart';
part 'user_credentials.g.dart';

@freezed
abstract class UserCredentials with _$UserCredentials {
  factory UserCredentials({
    required String token,
    ClientCertificate? clientCertificate,
    List<HeaderEntry>? additionalHeaders,
  }) = _UserCredentials;

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsFromJson(json);
}
