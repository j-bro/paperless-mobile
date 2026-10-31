import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';

Dio _stubDio(dynamic data, {int status = 200}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://paperless.example.com'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    h.resolve(Response(requestOptions: o, statusCode: status, data: data));
  }));
  return dio;
}

void main() {
  test('fetchProviders returns list on 200', () async {
    final api = OidcApi(_stubDio([
      {'id': 'authentik', 'name': 'Authentik'}
    ]));
    final providers = await api.fetchProviders('https://paperless.example.com');
    expect(providers.length, 1);
    expect(providers.first.id, 'authentik');
  });

  test('fetchProviders returns empty on 404 (old server)', () async {
    final api = OidcApi(_stubDio('not found', status: 404));
    expect(await api.fetchProviders('https://old.example.com'), isEmpty);
  });

  _exchangeTests();
}

void _exchangeTests() {
  test('provider exchange posts process, provider and token.client_id', () async {
    Map<String, dynamic>? posted;
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      posted = o.data as Map<String, dynamic>;
      h.resolve(Response(requestOptions: o, statusCode: 200, data: {
        'meta': {'session_token': 's1', 'access_token': 'drf-abc'}
      }));
    }));
    final api = OidcApi(dio);
    final r = await api.exchangeProviderToken(
        providerId: 'authentik', clientId: 'c1', idToken: 'id.x.y', accessToken: 'at');
    expect(r.accessToken, 'drf-abc');
    expect(r.mfaRequired, isFalse);
    // allauth headless contract (probed live 2026-10-31): `process` and
    // `token.client_id` are required; omitting either is a 400
    // (`required/param:process`, `client_id_required/param:token`).
    expect(posted!['process'], 'login');
    expect(posted!['provider'], 'authentik');
    expect(posted!['token'], {
      'client_id': 'c1',
      'id_token': 'id.x.y',
      'access_token': 'at',
    });
  });

  test('provider exchange omits access_token when absent', () async {
    Map<String, dynamic>? posted;
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      posted = o.data as Map<String, dynamic>;
      h.resolve(Response(requestOptions: o, statusCode: 200, data: {
        'meta': {'access_token': 'drf-abc'}
      }));
    }));
    final api = OidcApi(dio);
    await api.exchangeProviderToken(providerId: 'authentik', clientId: 'c1', idToken: 'id.x.y');
    expect((posted!['token'] as Map).containsKey('access_token'), isFalse);
  });

  test('401 mfa flow surfaces mfaRequired with session token', () async {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      h.resolve(Response(requestOptions: o, statusCode: 401, data: {
        'meta': {'is_authenticated': false, 'session_token': 's2'},
        'data': {'flows': [{'id': 'mfa_authenticate'}]}
      }));
    }));
    final api = OidcApi(dio);
    final r = await api.exchangeProviderToken(providerId: 'p', clientId: 'c1', idToken: 't');
    expect(r.mfaRequired, isTrue);
    expect(r.sessionToken, 's2');
  });

  test('410 gone maps to sessionExpired', () async {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      h.resolve(Response(requestOptions: o, statusCode: 410, data: {}));
    }));
    final api = OidcApi(dio);
    expect(() => api.exchangeProviderToken(providerId: 'p', clientId: 'c1', idToken: 't'),
        throwsA(isA<OidcSessionExpired>()));
  });
}
