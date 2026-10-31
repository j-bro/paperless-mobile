import 'package:bloc/bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_state.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/oidc_auth_facade.dart';

export 'oidc_state.dart';

class OidcCubit extends Cubit<OidcState> {
  final OidcApi _api;
  final OidcAuthFacade _facade;
  static const redirectUrl = 'paperlessmobile://oidc-callback';
  String? _sessionToken;

  OidcCubit(this._api, this._facade) : super(const OidcInitial());

  Future<void> start(OidcProvider provider) async {
    _sessionToken = null;
    emit(const OidcExchanging());
    logger.fd(
      'SSO direct flow started for provider ${provider.id}.',
      className: runtimeType.toString(),
      methodName: 'start',
    );
    try {
      final r = await _facade.authorize(provider: provider, redirectUrl: redirectUrl);
      if (r == null) {
        logger.fd(
          'SSO browser step cancelled, no token to exchange.',
          className: runtimeType.toString(),
          methodName: 'start',
        );
        emit(const OidcCancelled());
        return;
      }
      logger.fd(
        'SSO browser step returned tokens, exchanging with server.',
        className: runtimeType.toString(),
        methodName: 'start',
      );
      // The exchange needs the provider's published client_id (allauth
      // validates the id_token audience against the matching app entry).
      final clientId = provider.clientId;
      if (clientId == null || clientId.isEmpty) {
        logger.fw(
          'SSO provider ${provider.id} published no client id; cannot exchange.',
          className: runtimeType.toString(),
          methodName: 'start',
        );
        emit(const OidcError('OIDC sign-in failed. Please try again.', canRetry: true));
        return;
      }
      final ex = await _api.exchangeProviderToken(providerId: provider.id, clientId: clientId, idToken: r.idToken, accessToken: r.accessToken);
      if (ex.accessToken != null) {
        _sessionToken = null;
        logger.fi(
          'SSO exchange succeeded.',
          className: runtimeType.toString(),
          methodName: 'start',
        );
        emit(OidcSuccess(ex.accessToken!));
        return;
      }
      if (ex.mfaRequired && ex.sessionToken != null) {
        _sessionToken = ex.sessionToken;
        logger.fi(
          'SSO exchange requires second factor.',
          className: runtimeType.toString(),
          methodName: 'start',
        );
        emit(OidcOtpRequired(ex.sessionToken!));
        return;
      }
      logger.fw(
        'SSO exchange did not return a token.',
        className: runtimeType.toString(),
        methodName: 'start',
      );
      emit(const OidcError('OIDC exchange did not return a token.'));
    } on OidcSignupRequired {
      logger.fw(
        'SSO identity is not linked to a Paperless account.',
        className: runtimeType.toString(),
        methodName: 'start',
      );
      emit(const OidcError('Account is not linked. Log in via web UI once to link your SSO identity, then retry.', canRetry: false));
    } on OidcSessionExpired {
      logger.fw(
        'SSO session expired during exchange.',
        className: runtimeType.toString(),
        methodName: 'start',
      );
      emit(const OidcError('Session expired. Please retry.', canRetry: true));
    } catch (error, stackTrace) {
      logger.fe(
        'SSO sign-in failed.',
        className: runtimeType.toString(),
        methodName: 'start',
        error: error,
        stackTrace: stackTrace,
      );
      emit(const OidcError('OIDC sign-in failed. Please try again.', canRetry: true));
    }
  }

  Future<void> confirmMfa(String code) async {
    final s = _sessionToken;
    if (s == null) { emit(const OidcError('No pending session.', canRetry: false)); return; }
    emit(const OidcExchanging());
    try {
      final ex = await _api.confirmMfa(code: code, sessionToken: s);
      if (ex.accessToken != null) { _sessionToken = null; emit(OidcSuccess(ex.accessToken!)); return; }
      emit(const OidcError('Invalid code.', canRetry: true));
    } on OidcSessionExpired {
      emit(const OidcError('Session expired. Please retry.', canRetry: true));
    } catch (_) {
      emit(const OidcError('OIDC sign-in failed. Please try again.', canRetry: true));
    }
  }

  void cancel() {
    _sessionToken = null;
    emit(const OidcCancelled());
  }
}
