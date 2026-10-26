/// True when [pageUrl] is an authenticated app page on the same host as
/// [serverUrl] and no longer under `/accounts/` (i.e. SSO completed).
///
/// Requires same host so IdP pages (different origin) never count as an
/// active server session, and rejects scheme-less/malformed URLs.
bool isSsoSessionActive(String pageUrl, String serverUrl) {
  final page = Uri.tryParse(pageUrl);
  final server = Uri.tryParse(serverUrl);
  if (page == null || server == null) return false;
  if (!page.hasScheme || page.host.isEmpty) return false;
  if (!server.hasScheme || server.host.isEmpty) return false;
  if (page.host.toLowerCase() != server.host.toLowerCase()) return false;
  return !page.path.startsWith('/accounts/');
}

/// Normalized `.../accounts/login/?next=/dashboard/` initial URL for
/// [serverUrl], tolerant of a trailing slash on [serverUrl].
Uri buildSsoLoginUrl(String serverUrl) {
  final base = serverUrl.replaceAll(RegExp(r'/+$'), '');
  return Uri.parse('$base/accounts/login/?next=/dashboard/');
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
