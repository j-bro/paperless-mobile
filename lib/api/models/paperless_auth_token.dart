import 'package:freezed_annotation/freezed_annotation.dart';

part 'paperless_auth_token.freezed.dart';
part 'paperless_auth_token.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class PaperlessAuthToken with _$PaperlessAuthToken {
  factory PaperlessAuthToken({required String token}) = _PaperlessAuthToken;

  factory PaperlessAuthToken.fromJson(Map<String, dynamic> json) =>
      _$PaperlessAuthTokenFromJson(json);
}
