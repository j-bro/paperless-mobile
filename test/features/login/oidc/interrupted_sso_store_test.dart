import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/interrupted_sso_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<InterruptedSsoStore> _store() async =>
    InterruptedSsoStore(await SharedPreferences.getInstance());

InterruptedSsoAttempt _attempt({DateTime? startedAt}) => InterruptedSsoAttempt(
      serverUrl: 'https://x.example.com',
      provider: const OidcProvider(id: 'authentik', name: 'Example SSO'),
      startedAt: startedAt ?? DateTime.utc(2026, 10, 28, 12, 0, 0),
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('takeIfFresh returns a fresh attempt and consumes it', () async {
    final store = await _store();
    await store.save(_attempt());
    final now = DateTime.utc(2026, 10, 28, 12, 5, 0);
    final resumed = await store.takeIfFresh(now: now);
    expect(resumed?.serverUrl, 'https://x.example.com');
    expect(resumed?.provider.id, 'authentik');
    // Consumed: second take finds nothing.
    expect(await store.takeIfFresh(now: now), isNull);
  });

  test('stale attempts are cleared silently', () async {
    final store = await _store();
    await store.save(_attempt());
    final now = DateTime.utc(2026, 10, 28, 12, 31, 0);
    expect(await store.takeIfFresh(now: now), isNull);
    expect(await store.takeIfFresh(now: now), isNull);
  });

  test('missing attempt returns null', () async {
    final store = await _store();
    expect(await store.takeIfFresh(), isNull);
  });

  test('clear removes a pending attempt', () async {
    final store = await _store();
    await store.save(_attempt());
    await store.clear();
    expect(
      await store.takeIfFresh(now: DateTime.utc(2026, 10, 28, 12, 1, 0)),
      isNull,
    );
  });

  test('fromJson rejects malformed data', () async {    expect(InterruptedSsoAttempt.fromJson({}), isNull);
    expect(
      InterruptedSsoAttempt.fromJson({
        'serverUrl': '',
        'providerId': 'p',
        'startedAt': DateTime.utc(2026, 10, 28).toIso8601String(),
      }),
      isNull,
    );
    expect(
      InterruptedSsoAttempt.fromJson({
        'serverUrl': 'https://x.example.com',
        'providerId': 'p',
        'startedAt': 'not-a-date',
      }),
      isNull,
    );
  });

  test('parseRedirectObservationJson parses relay metadata', () {
    final obs = parseRedirectObservationJson(
      '{"receivedAtMillis":1761600000000,"scheme":"paperlessmobile",'
      '"host":"oidc-callback","hasCode":true,"hasState":true,'
      '"hasError":false,"error":null}',
    );
    expect(obs?.hasCode, isTrue);
    expect(obs?.hasState, isTrue);
    expect(obs?.hasError, isFalse);
    expect(obs?.error, isNull);
    expect(
      obs?.receivedAt,
      DateTime.fromMillisecondsSinceEpoch(1761600000000, isUtc: true),
    );
  });

  test('parseRedirectObservationJson rejects malformed input', () {
    expect(parseRedirectObservationJson(''), isNull);
    expect(parseRedirectObservationJson('not json'), isNull);
    expect(parseRedirectObservationJson('[]'), isNull);
    expect(parseRedirectObservationJson('{"hasCode":true}'), isNull);
  });

  test('drainRedirectObservation returns null without platform channels',
      () async {
    // No path_provider mock: must degrade gracefully, never throw.
    expect(await drainRedirectObservation(), isNull);
  });
}
