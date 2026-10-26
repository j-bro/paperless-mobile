import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/document_details/document_share/view/document_link_actions.dart';

void main() {
  test('builds details url and trims trailing slash', () {
    expect(
      buildDetailsUrl('https://paperless.example.com/', 123),
      'https://paperless.example.com/documents/123/',
    );
  });
  test('builds preview url', () {
    expect(
      buildPreviewUrl('https://paperless.example.com', 123),
      'https://paperless.example.com/api/documents/123/preview/',
    );
  });
  test('builds public share url', () {
    expect(
      buildPublicShareUrl('https://paperless.example.com/', 'abc123'),
      'https://paperless.example.com/share/abc123',
    );
  });
}
