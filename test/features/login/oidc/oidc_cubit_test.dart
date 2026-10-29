// test/features/login/oidc/oidc_cubit_test.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_cubit.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/oidc_auth_facade.dart';

class _FakeFacade implements OidcAuthFacade {
  final OidcBrowserResult? result;
  _FakeFacade(this.result);
  @override
  Future<OidcBrowserResult?> authorize({required OidcProvider provider, required String redirectUrl}) async => result;
}

class _TimeoutFacade implements OidcAuthFacade {
  @override
  Future<OidcBrowserResult?> authorize({required OidcProvider provider, required String redirectUrl}) async =>
      throw TimeoutException('SSO browser step produced no result within 180s.');
}

Dio _ok(String token) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    h.resolve(Response(requestOptions: o, statusCode: 200, data: {'meta': {'access_token': token}}));
  }));
  return dio;
}

Dio _seq(List<Map<String, dynamic>> bodies, {List<int> statuses = const []}) {
  int i = 0;
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
    final status = i < statuses.length ? statuses[i] : 200;
    h.resolve(Response(requestOptions: o, statusCode: status, data: bodies[i++]));
  }));
  return dio;
}

const _provider = OidcProvider(id: 'p', name: 'P');

void main() {
  setUpAll(() {
    // OidcCubit logs state transitions; init the global logger so unit
    // tests don't hit LateInitializationError.
    app_log.logger = Logger(level: Level.warning);
  });
  test('cancelled browser emits OidcCancelled', () async {
    final cubit = OidcCubit(OidcApi(_ok('x')), _FakeFacade(null));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcCancelled>());
  });

  test('successful exchange emits OidcSuccess', () async {
    final cubit = OidcCubit(OidcApi(_ok('drf-123')), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcSuccess>());
    expect((cubit.state as OidcSuccess).drfToken, 'drf-123');
  });

  test('mfaRequired emits OtpRequired', () async {
    final dio = _seq([
      {
        'meta': {'session_token': 's2'},
        'data': {'flows': [{'id': 'mfa_authenticate'}]}
      }
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcOtpRequired>());
    expect((cubit.state as OidcOtpRequired).sessionToken, 's2');
  });

  test('confirmMfa success emits OidcSuccess', () async {
    final dio = _seq([
      {
        'meta': {'session_token': 's2'},
        'data': {'flows': [{'id': 'mfa_authenticate'}]}
      },
      {
        'meta': {'access_token': 'drf-mfa'}
      },
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcOtpRequired>());
    await cubit.confirmMfa('123456');
    expect(cubit.state, isA<OidcSuccess>());
    expect((cubit.state as OidcSuccess).drfToken, 'drf-mfa');
  });

  test('confirmMfa invalid code emits OidcError', () async {
    final dio = _seq([
      {
        'meta': {'session_token': 's2'},
        'data': {'flows': [{'id': 'mfa_authenticate'}]}
      },
      {
        'meta': {}
      },
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    await cubit.confirmMfa('000000');
    expect(cubit.state, isA<OidcError>());
    expect((cubit.state as OidcError).message, contains('Invalid code'));
  });

  test('signup required emits non-retryable OidcError', () async {
    final dio = _seq([
      {
        'meta': {'session_token': 's3'},
        'data': {'flows': [{'id': 'provider_signup'}]}
      }
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcError>());
    final err = cubit.state as OidcError;
    expect(err.message, contains('not linked'));
    expect(err.canRetry, isFalse);
  });

  test('session expired emits retryable OidcError', () async {
    final dio = _seq([{}], statuses: [410]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcError>());
    final err = cubit.state as OidcError;
    expect(err.message, contains('Session expired'));
    expect(err.canRetry, isTrue);
  });

  test('no-token response emits OidcError', () async {
    final dio = _seq([
      {'meta': {}}
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcError>());
    expect((cubit.state as OidcError).message, contains('did not return a token'));
  });

  test('browser step timeout maps to retryable error', () async {
    final cubit = OidcCubit(OidcApi(_ok('x')), _TimeoutFacade());
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcError>());
    final err = cubit.state as OidcError;
    expect(err.message, 'OIDC sign-in failed. Please try again.');
    expect(err.canRetry, isTrue);
  });

  test('generic failure maps to user message without internals', () async {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      h.reject(DioException(requestOptions: o, type: DioExceptionType.connectionTimeout));
    }));
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcError>());
    final err = cubit.state as OidcError;
    expect(err.message, 'OIDC sign-in failed. Please try again.');
    expect(err.message, isNot(contains('Dio')));
  });

  test('cancel() emits OidcCancelled and clears pending session', () async {
    final dio = _seq([
      {
        'meta': {'session_token': 's2'},
        'data': {'flows': [{'id': 'mfa_authenticate'}]}
      },
    ]);
    final cubit = OidcCubit(OidcApi(dio), _FakeFacade(const OidcBrowserResult(idToken: 'id.t')));
    await cubit.start(_provider);
    expect(cubit.state, isA<OidcOtpRequired>());
    cubit.cancel();
    expect(cubit.state, isA<OidcCancelled>());
    await cubit.confirmMfa('123456');
    expect(cubit.state, isA<OidcError>());
    expect((cubit.state as OidcError).message, contains('No pending session'));
  });
}
