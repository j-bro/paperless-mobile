import 'package:dio/dio.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';

enum OidcFlow { direct, webFallback, none }

class OidcCapability {
  final OidcFlow flow;
  final List<OidcProvider> providers;
  const OidcCapability({required this.flow, this.providers = const []});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OidcCapability &&
          runtimeType == other.runtimeType &&
          flow == other.flow &&
          _providersEqual(providers, other.providers);

  @override
  int get hashCode => Object.hash(flow, Object.hashAll(providers));

  static bool _providersEqual(List<OidcProvider> a, List<OidcProvider> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

final _oidcLoginAction = RegExp(r'/accounts/oidc/([A-Za-z0-9_-]+)/login/');
final _oidcButtonText = RegExp(r'<button[^>]*>([^<]*)</button>', caseSensitive: false);
final _oidcFormBoundary = RegExp(r'<form|</li>', caseSensitive: false);

List<OidcProvider> parseLoginPageProviders(String html) {
  final seen = <String>{};
  final out = <OidcProvider>[];
  for (final m in _oidcLoginAction.allMatches(html)) {
    final id = m.group(1)!;
    if (!seen.add(id)) continue;
    // Constrain button search to this form: stop before next <form or </li>.
    final rest = html.substring(m.end);
    final boundary = _oidcFormBoundary.firstMatch(rest);
    final segment = boundary == null ? rest : rest.substring(0, boundary.start);
    final button = _oidcButtonText.firstMatch(segment);
    final text = button?.group(1)?.trim() ?? '';
    final name = text.isNotEmpty ? text : id[0].toUpperCase() + id.substring(1);
    out.add(OidcProvider(id: id, name: name));
  }
  return out;
}

class OidcApi {
  final Dio _dio;
  OidcApi(this._dio);

  List<OidcProvider> _extractProviders(dynamic data) {
    final list = data is List ? data : (data is Map ? (data['results'] ?? data['providers'] ?? []) : []);
    if (list is! List) return [];
    return list.whereType<Map>().map((e) => OidcProvider.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<OidcProvider>> _fetchProvidersFromPath(String serverUrl, String path) async {
    try {
      final res = await _dio.get(
        '$serverUrl$path',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );
      if (res.statusCode == 404) return [];
      return _extractProviders(res.data);
    } on DioException {
      return [];
    }
  }

  Future<List<OidcProvider>> fetchProviders(String serverUrl) async {
    try {
      return await _fetchProvidersFromPath(serverUrl, '/api/profile/social_account_providers/');
    } on DioException {
      return [];
    }
  }

  Future<List<OidcProvider>> _fetchProvidersAny(String serverUrl) async {
    for (final path in [
      '/api/profile/social_account_providers/',
      '/_allauth/app/v1/auth/provider/tokens',
      '/api/auth/app/v1/auth/provider/tokens',
    ]) {
      try {
        final providers = await _fetchProvidersFromPath(serverUrl, path);
        if (providers.isNotEmpty) return providers;
      } catch (_) {
        continue;
      }
    }
    return [];
  }

  Future<bool> _headlessAvailable(String serverUrl) async {
    try {
      final res = await _dio.get('$serverUrl/_allauth/app/v1/config',
          options: Options(headers: {'Accept': 'application/json'}, validateStatus: (s) => s != null && s < 500));
      final ct = res.headers.value('content-type') ?? '';
      return ct.contains('application/json') && res.data is Map;
    } catch (_) {
      return false;
    }
  }

  Future<List<OidcProvider>> _fetchLoginPageProviders(String serverUrl) async {
    try {
      final res = await _dio.get('$serverUrl/accounts/login/',
          options: Options(validateStatus: (s) => s != null && s < 500));
      if (res.statusCode == 200 && res.data is String) {
        return parseLoginPageProviders(res.data as String);
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<OidcCapability> detectCapabilities(String serverUrl) async {
    try {
      final headless = await _headlessAvailable(serverUrl);
      final metaProviders = await _fetchProvidersAny(serverUrl);
      if (headless && metaProviders.any((p) => (p.clientId?.isNotEmpty ?? false) && (p.discoveryUrl?.isNotEmpty ?? false))) {
        return OidcCapability(flow: OidcFlow.direct, providers: metaProviders);
      }
      final pageProviders = await _fetchLoginPageProviders(serverUrl);
      if (pageProviders.isNotEmpty) {
        return OidcCapability(flow: OidcFlow.webFallback, providers: pageProviders);
      }
      return const OidcCapability(flow: OidcFlow.none);
    } catch (_) {
      return const OidcCapability(flow: OidcFlow.none);
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
