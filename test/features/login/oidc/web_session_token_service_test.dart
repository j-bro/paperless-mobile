import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/login/oidc/service/web_session_token_service.dart';

void main() {
  test('login page is not an active session', () {
    expect(isSsoSessionActive('https://s.example.com/accounts/login/'), isFalse);
  });
  test('dashboard counts as active session', () {
    expect(isSsoSessionActive('https://s.example.com/dashboard/'), isTrue);
  });
  test('parses quoted token response', () {
    expect(parseGenerateTokenResponse('"abc123"'), 'abc123');
  });
  test('empty response -> null', () {
    expect(parseGenerateTokenResponse(''), isNull);
  });
}
