import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

part 'authentication_information.g.dart';

@JsonSerializable()
class AuthenticationInformation {
  String? token;
  String serverUrl;
  ClientCertificate? clientCertificate;
  String username;

  AuthenticationInformation({
    required this.username,
    required this.serverUrl,
    this.token,
    this.clientCertificate,
  });

  bool get isValid {
    return serverUrl.isNotEmpty && (token?.isNotEmpty ?? false);
  }
}
