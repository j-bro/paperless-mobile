bool isSsoSessionActive(String pageUrl) {
  final uri = Uri.tryParse(pageUrl);
  if (uri == null) return false;
  return !uri.path.startsWith('/accounts/');
}

String? parseGenerateTokenResponse(String body) {
  final t = body.trim().replaceAll('"', '').trim();
  return t.isEmpty ? null : t;
}

String buildGenerateTokenJs() => '''
(async () => {
  const m = document.cookie.match(/(?:^|; )csrftoken=([^;]*)/);
  const r = await fetch('/api/profile/generate_auth_token/', {
    method: 'POST',
    credentials: 'same-origin',
    headers: {'Content-Type': 'application/json', ...(m ? {'X-CSRFToken': decodeURIComponent(m[1])} : {})},
  });
  return await r.text();
})()
''';
