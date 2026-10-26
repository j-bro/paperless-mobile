import 'package:dio/dio.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';

class OidcApi {
  final Dio _dio;
  OidcApi(this._dio);

  Future<List<OidcProvider>> fetchProviders(String serverUrl) async {
    try {
      final res = await _dio.get(
        '$serverUrl/api/profile/social_account_providers/',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );
      if (res.statusCode == 404) return [];
      final data = res.data;
      final list = data is List ? data : (data is Map ? (data['results'] ?? data['providers'] ?? []) : []);
      if (list is! List) return [];
      return list.whereType<Map>().map((e) => OidcProvider.fromJson(Map<String, dynamic>.from(e))).toList();
    } on DioException {
      return [];
    }
  }
}

class OidcSessionExpired implements Exception {}

class OidcSignupRequired implements Exception {
  final String? sessionToken;
  OidcSignupRequired(this.sessionToken);
}

class OidcExchangeResult {
  final String? sessionToken;
  final String? accessToken;
  final bool mfaRequired;
  final bool signupRequired;
  const OidcExchangeResult({this.sessionToken, this.accessToken, this.mfaRequired = false, this.signupRequired = false});
}

extension OidcHeadlessApi on OidcApi {
  Map<String, String> _headers(String? sessionToken) =>
      sessionToken == null ? {} : {'X-Session-Token': sessionToken};

  OidcExchangeResult _parse(dynamic data) {
    final Map<dynamic, dynamic> root = data is Map ? data : const {};
    final meta = root['meta'] as Map? ?? {};
    final inner = root['data'] as Map?;
    final flows = inner?['flows'] as List? ?? [];
    final hasMfa = flows.any((f) => (f as Map)['id'] == 'mfa_authenticate');
    final hasSignup = flows.any((f) => (f as Map)['id'] == 'provider_signup');
    if (hasSignup) throw OidcSignupRequired(meta['session_token'] as String?);
    return OidcExchangeResult(
      sessionToken: meta['session_token'] as String?,
      accessToken: meta['access_token'] as String?,
      mfaRequired: hasMfa,
    );
  }

  Future<OidcExchangeResult> exchangeProviderToken({
    required String providerId,
    required String idToken,
    String? accessToken,
    String? sessionToken,
  }) async {
    final res = await _dio.post(
      '/_allauth/app/v1/auth/provider/token',
      data: {'provider': providerId, 'token': {'id_token': idToken, if (accessToken != null) 'access_token': accessToken}},
      options: Options(headers: _headers(sessionToken), validateStatus: (s) => s != null && s < 500),
    );
    if (res.statusCode == 410) throw OidcSessionExpired();
    return _parse(res.data);
  }

  Future<OidcExchangeResult> confirmMfa({required String code, required String sessionToken}) async {
    final res = await _dio.post(
      '/_allauth/app/v1/auth/mfa/authenticate',
      data: {'code': code},
      options: Options(headers: _headers(sessionToken), validateStatus: (s) => s != null && s < 500),
    );
    if (res.statusCode == 410) throw OidcSessionExpired();
    return _parse(res.data);
  }
}
