// test/features/login/oidc/oidc_capability_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';

Dio _stub(List<({String path, int status, dynamic data, String contentType})> routes) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    final m = routes.where((r) => o.uri.toString().endsWith(r.path)).toList();
    if (m.isEmpty) return h.resolve(Response(requestOptions: o, statusCode: 404, data: 'x'));
    final r = m.first;
    return h.resolve(Response(requestOptions: o, statusCode: r.status,
        data: r.data, headers: Headers.fromMap({'content-type': [r.contentType]})));
  }));
  return dio;
}

const _loginHtml = '<form method="POST" action="/accounts/oidc/authentik/login/?process=">';

void main() {
  test('headless JSON + provider client data -> direct', () async {
    final api = OidcApi(_stub([
      (path: '/_allauth/app/v1/config', status: 200, data: {'data': {'flows': []}}, contentType: 'application/json'),
      (path: '/api/profile/social_account_providers/', status: 200,
          data: [{'id': 'authentik', 'name': 'Authentik', 'discovery_url': 'https://id.example/.well-known/openid-configuration', 'client_id': 'c1'}],
          contentType: 'application/json'),
      (path: '/accounts/login/', status: 200, data: _loginHtml, contentType: 'text/html'),
    ]));
    final cap = await api.detectCapabilities('https://x.example.com');
    expect(cap.flow, OidcFlow.direct);
    expect(cap.providers.first.clientId, 'c1');
  });

  test('paperless v3 headless mount with client data -> direct', () async {
    final api = OidcApi(_stub([
      (path: '/api/auth/headless/app/v1/config', status: 200,
          data: {'status': 200, 'data': {'socialaccount': {'providers': [
            {'id': 'authentik', 'name': 'Example SSO', 'client_id': 'c1', 'openid_configuration_url': 'https://id.example/.well-known/openid-configuration'}
          ]}}},
          contentType: 'application/json'),
      (path: '/accounts/login/', status: 200, data: _loginHtml, contentType: 'text/html'),
    ]));
    final cap = await api.detectCapabilities('https://x.example.com');
    expect(cap.flow, OidcFlow.direct);
    expect(cap.providers.single.id, 'authentik');
    expect(cap.providers.single.clientId, 'c1');
    expect(cap.providers.single.discoveryUrl, contains('openid-configuration'));
  });

  test('login page lists providers but no headless -> webFallback', () async {
    final api = OidcApi(_stub([
      (path: '/_allauth/app/v1/config', status: 302, data: '<html></html>', contentType: 'text/html'),
      (path: '/api/profile/social_account_providers/', status: 401, data: {'detail': 'x'}, contentType: 'application/json'),
      (path: '/accounts/login/', status: 200, data: _loginHtml, contentType: 'text/html'),
    ]));
    final cap = await api.detectCapabilities('https://paperless.example.com');
    expect(cap.flow, OidcFlow.webFallback);
    expect(cap.providers.map((p) => p.id), contains('authentik'));
  });

  test('nothing available -> none, never throws', () async {
    final api = OidcApi(_stub([]));
    final cap = await api.detectCapabilities('https://down.example.com');
    expect(cap.flow, OidcFlow.none);
  });

  test('uses web button text as provider name', () {
    const html = '<form method="POST" action="/accounts/oidc/authentik/login/?process=">'
        '<button type="submit" class="btn btn-secondary">Example SSO</button></form>';
    final ps = parseLoginPageProviders(html);
    expect(ps.single.id, 'authentik');
    expect(ps.single.name, 'Example SSO');
  });
  test('falls back to capitalized id without button text', () {
    const html = '<form action="/accounts/oidc/foo/login/">x</form>';
    expect(parseLoginPageProviders(html).single.name, 'Foo');
  });
}
