import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/view/oidc_login_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness(Widget body) => MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      home: Scaffold(body: body),
    );

void main() {
  setUpAll(() {
    // OidcLoginButton logs web-fallback results (length only); init the
    // global logger so widget tests don't hit LateInitializationError.
    app_log.logger = Logger(level: Level.warning);
    // The button persists SSO attempts via SharedPreferences; the platform
    // channel never resolves in tests, so use the in-memory mock.
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('shows SSO button when providers present', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [OidcProvider(id: 'p', name: 'Authentik')],
    )));
    expect(find.text('Continue with Authentik'), findsOneWidget);
  });

  testWidgets('shows fallback hint for secret-required IdP error', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [],
      forceVisibleForTest: true,
    )));
    expect(find.text('Continue with SSO'), findsOneWidget);
  });

  testWidgets('hides button when flow is none', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [OidcProvider(id: 'p', name: 'Authentik')],
      flow: OidcFlow.none,
    )));
    expect(find.text('Continue with Authentik'), findsNothing);
  });

  testWidgets('shows SSO button for webFallback flow', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [OidcProvider(id: 'p', name: 'Authentik')],
      flow: OidcFlow.webFallback,
    )));
    expect(find.text('Continue with Authentik'), findsOneWidget);
  });

  testWidgets('webFallback tap routes to the web SSO page', (t) async {
    var opened = false;
    await t.pumpWidget(_harness(OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: const [OidcProvider(id: 'p', name: 'Authentik')],
      flow: OidcFlow.webFallback,
      openWebSsoPage: (_) async {
        opened = true;
        return null; // user cancelled
      },
    )));
    await t.tap(find.text('Continue with Authentik'));
    await t.pumpAndSettle();
    expect(opened, isTrue);
  });

  testWidgets('direct tap does not route to the web SSO page', (t) async {
    var opened = false;
    await t.pumpWidget(_harness(OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: const [OidcProvider(id: 'p', name: 'Authentik')],
      flow: OidcFlow.direct,
      openWebSsoPage: (_) async {
        opened = true;
        return null;
      },
    )));
    await t.tap(find.text('Continue with Authentik'));
    await t.pump();
    expect(opened, isFalse);
  });
}
