import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/login/oidc/service/web_session_token_service.dart';

void main() {
  const server = 'https://s.example.com';

  test('login page is not an active session', () {
    expect(
      isSsoSessionActive('https://s.example.com/accounts/login/', server),
      isFalse,
    );
  });
  test('dashboard counts as active session', () {
    expect(
      isSsoSessionActive('https://s.example.com/dashboard/', server),
      isTrue,
    );
  });
  test('foreign host with app-like path is not an active session', () {
    expect(
      isSsoSessionActive('https://idp.example.org/dashboard/', server),
      isFalse,
    );
  });
  test('same host under /accounts/ subpath is not active', () {
    expect(
      isSsoSessionActive('https://s.example.com/accounts/oidc/authentik/login/', server),
      isFalse,
    );
  });
  test('malformed or scheme-less page URL is not active', () {
    expect(isSsoSessionActive('not a url', server), isFalse);
    expect(isSsoSessionActive('s.example.com/dashboard/', server), isFalse);
  });
  test('trailing-slash serverUrl still matches same host', () {
    expect(
      isSsoSessionActive(
        'https://s.example.com/documents/',
        'https://s.example.com/',
      ),
      isTrue,
    );
  });
  test('parses quoted token response', () {
    expect(parseGenerateTokenResponse('"abc123"'), 'abc123');
  });
  test('empty response -> null', () {
    expect(parseGenerateTokenResponse(''), isNull);
  });
  test('buildSsoLoginUrl normalizes trailing slash', () {
    expect(
      buildSsoLoginUrl('https://s.example.com/').toString(),
      'https://s.example.com/accounts/login/?next=/dashboard/',
    );
    expect(
      buildSsoLoginUrl('https://s.example.com').toString(),
      'https://s.example.com/accounts/login/?next=/dashboard/',
    );
  });
}
