import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

part 'user_credentials.freezed.dart';
part 'user_credentials.g.dart';

@freezed
abstract class UserCredentials with _$UserCredentials {
  factory UserCredentials({
    required String token,
    ClientCertificate? clientCertificate,
  }) = _UserCredentials;

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsFromJson(json);
}
