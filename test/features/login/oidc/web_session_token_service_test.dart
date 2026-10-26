import 'dart:convert';

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
    final token = 'a' * 40;
    expect(parseMintResult(200, '"$token"'), token);
  });
  test('short token rejected', () {
    expect(parseMintResult(200, '"abc123"'), isNull);
  });
  test('empty response -> null', () {
    expect(parseMintResult(200, ''), isNull);
  });
  test('non-200 mint result -> null even with body', () {
    expect(parseMintResult(403, '{"detail":"CSRF Failed"}'), isNull);
  });
  test('200 HTML error page -> null', () {
    expect(parseMintResult(200, '<html>nope</html>'), isNull);
  });
  test('200 40-hex token (quoted) -> token', () {
    expect(parseMintResult(200, '"${'a' * 40}"'), 'a' * 40);
  });
  test('mint JS bridge single-encoded success -> token', () {
    final token = 'b' * 40;
    final raw = jsonEncode({'status': 200, 'body': '"$token"'});
    expect(parseMintJsResult(raw), token);
  });
  test('mint JS bridge double-encoded success -> token', () {
    final token = 'c' * 40;
    final inner = jsonEncode({'status': 200, 'body': token});
    final raw = jsonEncode(inner);
    expect(parseMintJsResult(raw), token);
  });
  test('mint JS bridge 403 -> null', () {
    final raw = jsonEncode({'status': 403, 'body': '{"detail":"CSRF Failed"}'});
    expect(parseMintJsResult(raw), isNull);
  });
  test('mint JS bridge malformed -> null', () {
    expect(parseMintJsResult('not json'), isNull);
    expect(parseMintJsResult('"just a string"'), isNull);
  });
  test('mint status extracted for logging (int only)', () {
    final token = 'd' * 40;
    final raw = jsonEncode({'status': 200, 'body': token});
    expect(tryParseMintStatus(raw), 200);
    expect(tryParseMintStatus(jsonEncode(raw)), 200);
    final bad = jsonEncode({'status': 403, 'body': 'nope'});
    expect(tryParseMintStatus(bad), 403);
    expect(tryParseMintStatus('not json'), isNull);
  });
  test('buildGenerateTokenJs returns status-gated JSON', () {
    final js = buildGenerateTokenJs();
    expect(js, contains('JSON.stringify'));
    expect(js, contains('status'));
    expect(js, contains('generate_auth_token'));
  });
  test('parseMintJsResult2 parses cookie names (values excluded)', () {
    final raw = jsonEncode({
      'status': 403,
      'body': '{"detail":"CSRF Failed"}',
      'cookieNames': ['csrftoken', 'sessionid'],
    });
    final r = parseMintJsResult2(raw);
    expect(r, isNotNull);
    expect(r!.status, 403);
    expect(r.body, '{"detail":"CSRF Failed"}');
    expect(r.cookieNames, ['csrftoken', 'sessionid']);
    // Names only: no '=' and no values leak into names.
    for (final n in r.cookieNames) {
      expect(n.contains('='), isFalse);
    }
  });
  test('parseMintJsResult2 strips values from cookie entries defensively', () {
    final raw = jsonEncode({
      'status': 200,
      'body': 'x',
      'cookieNames': ['csrftoken=abc123', ' sessionid '],
    });
    final r = parseMintJsResult2(raw);
    expect(r, isNotNull);
    expect(r!.cookieNames, ['csrftoken', 'sessionid']);
  });
  test('parseMintJsResult2 double-encoded with cookie names', () {
    final inner = jsonEncode({
      'status': 200,
      'body': 'tok',
      'cookieNames': ['csrftoken'],
    });
    final r = parseMintJsResult2(jsonEncode(inner));
    expect(r, isNotNull);
    expect(r!.status, 200);
    expect(r.cookieNames, ['csrftoken']);
  });
  test('parseMintJsResult2 missing cookieNames -> empty list', () {
    final raw = jsonEncode({'status': 200, 'body': 'tok'});
    final r = parseMintJsResult2(raw);
    expect(r, isNotNull);
    expect(r!.cookieNames, isEmpty);
  });
  test('parseMintJsResult2 malformed -> null', () {
    expect(parseMintJsResult2('not json'), isNull);
    expect(parseMintJsResult2(jsonEncode({'status': 'x'})), isNull);
  });
  test('parseMintJsResult2 surfaces status for diagnostics', () {
    final raw = jsonEncode({
      'status': 403,
      'body': 'forbidden',
      'cookieNames': <String>[],
    });
    expect(parseMintJsResult2(raw)!.status, 403);
  });
  test('buildGenerateTokenJs exposes cookie names only (no values)', () {
    final js = buildGenerateTokenJs();
    expect(js, contains('cookieNames'));
    expect(js, contains("split('=')[0]"));
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
