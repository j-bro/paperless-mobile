import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';

void main() {
  test('parses provider with discovery url and client id', () {
    final p = OidcProvider.fromJson({
      'id': 'authentik',
      'name': 'Authentik',
      'discovery_url': 'https://id.example.com/.well-known/openid-configuration',
      'client_id': 'paperless-mobile',
    });
    expect(p.id, 'authentik');
    expect(p.discoveryUrl, contains('openid-configuration'));
    expect(p.clientId, 'paperless-mobile');
  });

  test('tolerates minimal provider shape', () {
    final p = OidcProvider.fromJson({'id': 'x', 'name': 'X'});
    expect(p.discoveryUrl, isNull);
  });
}
