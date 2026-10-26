import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/server_connection/cubit/server_connection_cubit.dart';

void main() {
  test('success states with equal providers are equal', () {
    // NOTE: intentionally non-const: const instances are canonicalized and
    // would compare equal even with identity equality.
    final a = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    final b = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });

  test('success states with different providers are distinct', () {
    final a = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    final b = ServerConnectionSuccess(
      serverUrl: 'https://x.example.com',
      oidcProviders: [OidcProvider(id: 'p', name: 'Authentik')],
    );
    expect(a, isNot(equals(b)));
  });

  test('checkReachability emits success carrying discovered providers',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((req) async {
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode([
        {'id': 'p', 'name': 'Authentik'},
      ]));
      await req.response.close();
    });

    final address = 'http://127.0.0.1:${server.port}';
    final cubit = ServerConnectionCubit(ConnectivityStatusServiceMock(true));
    addTearDown(cubit.close);
    cubit.checkReachability(address: address);
    final state = await cubit.stream
        .firstWhere((s) => s is ServerConnectionSuccess)
        .timeout(const Duration(seconds: 15));

    final success = state as ServerConnectionSuccess;
    expect(success.oidcProviders.map((p) => p.id), contains('p'));
    // State equality must capture the discovered providers, so a success
    // carrying providers is distinct from one without.
    expect(
      success,
      equals(ServerConnectionSuccess(
        serverUrl: address,
        oidcProviders: [OidcProvider(id: 'p', name: 'Authentik')],
      )),
    );
    expect(
      success,
      isNot(equals(ServerConnectionSuccess(serverUrl: address))),
    );
  });
}
