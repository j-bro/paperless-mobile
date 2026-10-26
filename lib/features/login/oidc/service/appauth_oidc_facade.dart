import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/oidc_auth_facade.dart';

class AppAuthOidcFacade implements OidcAuthFacade {
  final FlutterAppAuth _appAuth;
  AppAuthOidcFacade([FlutterAppAuth? appAuth]) : _appAuth = appAuth ?? const FlutterAppAuth();

  @override
  Future<OidcBrowserResult?> authorize({required OidcProvider provider, required String redirectUrl}) async {
    final discoveryUrl = provider.discoveryUrl;
    final clientId = provider.clientId;
    if (discoveryUrl == null || clientId == null || discoveryUrl.isEmpty || clientId.isEmpty) {
      throw StateError('Provider ${provider.id} is missing discovery URL or client ID.');
    }
    AuthorizationTokenResponse result;
    try {
      result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          scopes: const ['openid', 'profile', 'email'],
        ),
      );
    } on PlatformException {
      // User cancelled the browser flow (flutter_appauth v7 throws instead of
      // returning null). Surface as null per the OidcAuthFacade contract.
      return null;
    }
    if (result.idToken == null) throw StateError('IdP did not return an id_token.');
    return OidcBrowserResult(idToken: result.idToken!, accessToken: result.accessToken);
  }
}
