import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// In-memory platform fake: constructing the real service subscribes to
/// connectivity changes, which needs platform channels that don't exist in
/// unit tests. A quiet stream keeps construction side-effect free.
class _FakeConnectivityPlatform extends ConnectivityPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.empty();
}

void main() {
  setUpAll(() {
    app_log.logger = Logger(level: Level.warning);
    ConnectivityPlatform.instance = _FakeConnectivityPlatform();
  });
  test('hanging schema endpoint falls back to statistics (reachable)',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      if (req.uri.path == '/api/schema/') {
        // Never respond: the client's 5s timeout must trigger the
        // statistics fallback instead of failing the check.
        await Completer<void>().future;
      } else if (req.uri.path == '/api/statistics/') {
        req.response.statusCode = HttpStatus.unauthorized;
        await req.response.close();
      } else {
        req.response.statusCode = HttpStatus.notFound;
        await req.response.close();
      }
    });

    final service = ConnectivityStatusServiceImpl(Connectivity());
    final status = await service.isPaperlessServerReachable(
      'http://127.0.0.1:${server.port}',
    );
    expect(status, ReachabilityStatus.reachable);
  });

  test('refused connection stays unreachable', () async {
    // Bind then close to get a guaranteed-closed local port.
    final probe = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final port = probe.port;
    await probe.close(force: true);

    final service = ConnectivityStatusServiceImpl(Connectivity());
    final status = await service.isPaperlessServerReachable(
      'http://127.0.0.1:$port',
    );
    expect(status, ReachabilityStatus.notReachable);
  });
}
