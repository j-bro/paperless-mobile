import 'dart:convert';

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

/// Strict mint validator: returns the token ONLY when [status] is 200 and
/// the trimmed body (quotes stripped) matches `^[A-Za-z0-9]{32,}$`.
/// DRF tokens are 40-hex; this rejects HTML/JSON error pages and CSRF 403s
/// whose bodies would otherwise be mistaken for a token.
String? parseMintResult(int status, String body) {
  if (status != 200) return null;
  final t = body.trim().replaceAll('"', '').trim();
  if (t.isEmpty) return null;
  if (!RegExp(r'^[A-Za-z0-9]{32,}$').hasMatch(t)) return null;
  return t;
}

/// Extracts the HTTP status from the raw `runJavaScriptReturningResult`
/// value of [buildGenerateTokenJs] for logging (int only — safe).
/// Returns null when the shape is unexpected.
int? tryParseMintStatus(String raw) {
  try {
    dynamic decoded = jsonDecode(raw);
    if (decoded is String) {
      decoded = jsonDecode(decoded);
    }
    if (decoded is Map) {
      final status = decoded['status'];
      if (status is int) return status;
      if (status is num) return status.toInt();
    }
    return null;
  } catch (_) {
    return null;
  }
}

/// Decodes the raw `runJavaScriptReturningResult` value of
/// [buildGenerateTokenJs] into a token.
///
/// The WebView bridge returns a JSON-encoded string, so [raw] may need one
/// or two `jsonDecode` passes before yielding
/// `{status: int, body: String}`. Returns null on any shape/status failure.
/// Never logs or returns the token value itself (callers log lengths only).
String? parseMintJsResult(String raw) {
  try {
    dynamic decoded = jsonDecode(raw);
    // Bridge double-encodes: first decode may yield the inner JSON string.
    if (decoded is String) {
      decoded = jsonDecode(decoded);
    }
    if (decoded is Map) {
      final status = decoded['status'];
      final body = decoded['body'];
      if (status is int && body is String) {
        return parseMintResult(status, body);
      }
      // Status may arrive as num (e.g. from JS number); coerce safely.
      if (status is num && body is String) {
        return parseMintResult(status.toInt(), body);
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}

String buildGenerateTokenJs() => '''
(async () => {
  const m = document.cookie.match(/(?:^|; )csrftoken=([^;]*)/);
  const r = await fetch('/api/profile/generate_auth_token/', {
    method: 'POST',
    credentials: 'same-origin',
    headers: {'Content-Type': 'application/json', ...(m ? {'X-CSRFToken': decodeURIComponent(m[1])} : {})},
  });
  return JSON.stringify({status: r.status, body: await r.text()});
})()
''';
