import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/server_connection/cubit/server_connection_cubit.dart';

void main() {
  setUpAll(() {
    // Capability detection logs through the global logger; init it so
    // tests don't hit LateInitializationError.
    app_log.logger = Logger(level: Level.warning);
  });  test('success states with equal capabilities are equal', () {
    // NOTE: intentionally non-const: const instances are canonicalized and
    // would compare equal even with identity equality.
    final a = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    final b = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });

  test('success states with different capabilities are distinct', () {
    final a = ServerConnectionSuccess(serverUrl: 'https://x.example.com');
    final b = ServerConnectionSuccess(
      serverUrl: 'https://x.example.com',
      oidcCapability: OidcCapability(
        flow: OidcFlow.direct,
        providers: [OidcProvider(id: 'p', name: 'Authentik')],
      ),
    );
    expect(a, isNot(equals(b)));
  });

  test('checkReachability emits success carrying detected capability',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((req) async {
      final path = req.uri.path;
      if (path.endsWith('/_allauth/app/v1/config')) {
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'data': {'flows': []}}));
      } else if (path.endsWith('/api/profile/social_account_providers/')) {
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode([
          {
            'id': 'p',
            'name': 'Authentik',
            'discovery_url':
                'https://id.example.com/.well-known/openid-configuration',
            'client_id': 'c1',
          },
        ]));
      } else {
        req.response.headers.contentType = ContentType.html;
        req.response.write('<html></html>');
      }
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
    expect(success.oidcCapability.flow, OidcFlow.direct);
    expect(success.oidcProviders.map((p) => p.id), contains('p'));
    // State equality must capture the detected capability, so a success
    // carrying providers is distinct from one without.
    expect(
      success,
      equals(ServerConnectionSuccess(
        serverUrl: address,
        oidcCapability: OidcCapability(
          flow: OidcFlow.direct,
          providers: [
            OidcProvider(
              id: 'p',
              name: 'Authentik',
              discoveryUrl:
                  'https://id.example.com/.well-known/openid-configuration',
              clientId: 'c1',
            ),
          ],
        ),
      )),
    );
    expect(
      success,
      isNot(equals(ServerConnectionSuccess(serverUrl: address))),
    );
  });
}
