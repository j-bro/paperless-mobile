import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/view/oidc_login_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

Widget _harness(Widget body) => MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      home: Scaffold(body: body),
    );

void main() {
  testWidgets('shows SSO button when providers present', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [OidcProvider(id: 'p', name: 'Authentik')],
    )));
    expect(find.textContaining('SSO'), findsOneWidget);
  });

  testWidgets('shows fallback hint for secret-required IdP error', (t) async {
    await t.pumpWidget(_harness(const OidcLoginButton(
      serverUrl: 'https://x.example.com',
      providers: [],
      forceVisibleForTest: true,
    )));
    expect(find.textContaining('SSO'), findsOneWidget);
  });
}
