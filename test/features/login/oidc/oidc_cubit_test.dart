// test/features/login/oidc/oidc_cubit_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_cubit.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/oidc_auth_facade.dart';

class _FakeFacade implements OidcAuthFacade {
  final OidcBrowserResult? result;
  _FakeFacade(this.result);
  @override
  Future<OidcBrowserResult?> authorize({required OidcProvider provider, required String redirectUrl}) async => result;
}

Dio _ok(String token) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    h.resolve(Response(requestOptions: o, statusCode: 200, data: {'meta': {'access_token': token}}));
  }));
  return dio;
}

void main() {
  test('cancelled browser emits OidcCancelled', () async {
    final cubit = OidcCubit(OidcApi(_ok('x')), _FakeFacade(null));
    cubit.start(const OidcProvider(id: 'p', name: 'P'));
    await Future.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<OidcCancelled>());
  });

  test('successful exchange emits OidcSuccess', () async {
    final cubit = OidcCubit(OidcApi(_ok('drf-123')), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    cubit.start(const OidcProvider(id: 'p', name: 'P'));
    await Future.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<OidcSuccess>());
    expect((cubit.state as OidcSuccess).drfToken, 'drf-123');
  });
}
