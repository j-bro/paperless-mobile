import 'package:paperless_api/generated/lib/src/model/paperless_auth_token_request.dart';

abstract class PaperlessAuthenticationApi {
  ///
  /// Returns an authentication token.
  ///
  Future<String> token(PaperlessAuthTokenRequest request);

  String getOAuthCallback();
}
