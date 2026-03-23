import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_credentials.g.dart';
part 'authentication_credentials.freezed.dart';

@freezed
sealed class AuthenticationCredentials with _$AuthenticationCredentials {
  const factory AuthenticationCredentials.password({
    required String username,
    required String password,
  }) = PasswordAuthenticationCredentials;

  const factory AuthenticationCredentials.apiKey({required String apiKey}) =
      ApiKeyAuthenticationCredentials;

  factory AuthenticationCredentials.fromJson(Map<String, Object?> json) =>
      _$AuthenticationCredentialsFromJson(json);
}
