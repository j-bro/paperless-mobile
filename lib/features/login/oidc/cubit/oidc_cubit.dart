import 'package:bloc/bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
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
    emit(const OidcExchanging());
    try {
      final r = await _facade.authorize(provider: provider, redirectUrl: redirectUrl);
      if (r == null) { emit(const OidcCancelled()); return; }
      final ex = await _api.exchangeProviderToken(providerId: provider.id, idToken: r.idToken, accessToken: r.accessToken);
      if (ex.accessToken != null) { emit(OidcSuccess(ex.accessToken!)); return; }
      if (ex.mfaRequired && ex.sessionToken != null) {
        _sessionToken = ex.sessionToken;
        emit(OidcOtpRequired(ex.sessionToken!));
        return;
      }
      emit(const OidcError('OIDC exchange did not return a token.'));
    } on OidcSignupRequired {
      emit(const OidcError('Account is not linked. Log in via web UI once to link your SSO identity, then retry.'));
    } on OidcSessionExpired {
      emit(const OidcError('Session expired. Please retry.'));
    } catch (e) {
      emit(OidcError(e.toString()));
    }
  }

  Future<void> confirmMfa(String code) async {
    final s = _sessionToken;
    if (s == null) { emit(const OidcError('No pending session.')); return; }
    emit(const OidcExchanging());
    try {
      final ex = await _api.confirmMfa(code: code, sessionToken: s);
      if (ex.accessToken != null) { emit(OidcSuccess(ex.accessToken!)); return; }
      emit(const OidcError('Invalid code.'));
    } on OidcSessionExpired {
      emit(const OidcError('Session expired. Please retry.'));
    } catch (e) {
      emit(OidcError(e.toString()));
    }
  }
}
