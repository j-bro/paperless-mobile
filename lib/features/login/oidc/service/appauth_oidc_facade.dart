import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
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
      // Log host only: the discovery URL carries no secrets, but full URLs
      // (and everything after this point: codes, tokens) stay out of logs.
      final host = Uri.tryParse(discoveryUrl)?.host ?? 'unknown';
      logger.fd(
        'AppAuth browser flow started for provider ${provider.id} on host $host.',
        className: runtimeType.toString(),
        methodName: 'authorize',
      );
      result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          scopes: const ['openid', 'profile', 'email'],
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      // Canonical v7 user-cancel signal (user closed the system browser).
      // Surface as null per the OidcAuthFacade contract.
      logger.fd(
        'AppAuth browser flow cancelled by user.',
        className: runtimeType.toString(),
        methodName: 'authorize',
      );
      return null;
    } on PlatformException catch (e) {
      // Fallback for raw channel errors that never got mapped to the typed
      // exception above: only treat genuine cancel codes/messages as cancel.
      if (_isUserCancel(e)) {
        logger.fd(
          'AppAuth browser flow cancelled by user (platform code ${e.code}).',
          className: runtimeType.toString(),
          methodName: 'authorize',
        );
        return null;
      }
      logger.fw(
        'AppAuth browser flow failed with platform error ${e.code}.',
        className: runtimeType.toString(),
        methodName: 'authorize',
        error: e.message,
      );
      rethrow;
    } catch (error, stackTrace) {
      logger.fe(
        'AppAuth browser flow failed.',
        className: runtimeType.toString(),
        methodName: 'authorize',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
    if (result.idToken == null) {
      logger.fw(
        'IdP did not return an id_token.',
        className: runtimeType.toString(),
        methodName: 'authorize',
      );
      throw StateError('IdP did not return an id_token.');
    }
    // Lengths only, never values.
    logger.fi(
      'AppAuth browser flow returned tokens (id ${result.idToken!.length}, access ${result.accessToken?.length ?? 0}).',
      className: runtimeType.toString(),
      methodName: 'authorize',
    );
    return OidcBrowserResult(idToken: result.idToken!, accessToken: result.accessToken);
  }
}

/// True only for genuine user-cancel signals on the raw [PlatformException]
/// path. The typed [FlutterAppAuthUserCancelledException] is handled first;
/// this covers legacy/unmapped channel errors (e.g. `user_cancel`,
/// `USER_CANCELED_AUTH_FLOW`, `cancelled`/`canceled` variants).
bool _isUserCancel(PlatformException e) {
  final code = e.code.toLowerCase();
  const cancelCodeFragments = [
    'user_cancel',
    'user-cancel',
    'user_canceled',
    'user_cancelled',
    'cancelled',
    'canceled',
  ];
  if (cancelCodeFragments.any(code.contains)) return true;
  final message = (e.message ?? '').toLowerCase();
  if (message.contains('user cancel') ||
      message.contains('user cancelled') ||
      message.contains('user canceled')) {
    return true;
  }
  return false;
}
