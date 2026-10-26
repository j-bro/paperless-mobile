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

Dio _seqDio(List<Map<String, dynamic>> bodies) {
  int i = 0;
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    h.resolve(Response(requestOptions: o, statusCode: 200, data: bodies[i++]));
  }));
  return dio;
}

void _exchangeTests() {
  test('provider exchange returns access token', () async {
    final api = OidcApi(_seqDio([
      {'meta': {'session_token': 's1', 'access_token': 'drf-abc'}}
    ]));
    final r = await api.exchangeProviderToken(providerId: 'authentik', idToken: 'id.x.y');
    expect(r.accessToken, 'drf-abc');
    expect(r.mfaRequired, isFalse);
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
    final r = await api.exchangeProviderToken(providerId: 'p', idToken: 't');
    expect(r.mfaRequired, isTrue);
    expect(r.sessionToken, 's2');
  });

  test('410 gone maps to sessionExpired', () async {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      h.resolve(Response(requestOptions: o, statusCode: 410, data: {}));
    }));
    final api = OidcApi(dio);
    expect(() => api.exchangeProviderToken(providerId: 'p', idToken: 't'),
        throwsA(isA<OidcSessionExpired>()));
  });
}
