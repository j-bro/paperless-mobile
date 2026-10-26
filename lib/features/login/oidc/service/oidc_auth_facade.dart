import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';

class OidcBrowserResult {
  final String idToken;
  final String? accessToken;
  const OidcBrowserResult({required this.idToken, this.accessToken});
}

abstract class OidcAuthFacade {
  Future<OidcBrowserResult?> authorize({required OidcProvider provider, required String redirectUrl});
}
