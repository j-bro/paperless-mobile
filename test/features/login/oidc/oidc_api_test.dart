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
}
