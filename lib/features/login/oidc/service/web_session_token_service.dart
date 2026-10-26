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

/// Decoded mint bridge result: HTTP status, raw body, and cookie NAMES
/// only (never values — values never leave the WebView).
typedef MintJsResult = ({int status, String body, List<String> cookieNames});

/// Shared core: decodes an already-`jsonDecode`d value into
/// `{status, body, cookieNames}`. `cookieNames` defaults to `[]` when absent
/// (older bridge shape); entries are sanitized to names only (split on '=',
/// trim, drop empties) so cookie values can never leak.
MintJsResult? _parseMintDecoded(dynamic decoded) {
  // Channel bridge delivers a raw JSON string; tolerate one extra layer of
  // encoding for legacy `runJavaScriptReturningResult` return values.
  if (decoded is String) {
    try {
      decoded = jsonDecode(decoded);
    } catch (_) {
      return null;
    }
  }
  if (decoded is Map) {
    final statusDyn = decoded['status'];
    final bodyDyn = decoded['body'];
    int? status;
    if (statusDyn is int) {
      status = statusDyn;
    } else if (statusDyn is num) {
      // Status may arrive as num (e.g. from JS number); coerce safely.
      status = statusDyn.toInt();
    }
    if (status == null || bodyDyn is! String) return null;
    final cookieNames = <String>[];
    final rawNames = decoded['cookieNames'];
    if (rawNames is List) {
      for (final e in rawNames) {
        if (e is String) {
          final name = e.split('=').first.trim();
          if (name.isNotEmpty) cookieNames.add(name);
        }
      }
    }
    return (status: status, body: bodyDyn, cookieNames: cookieNames);
  }
  return null;
}

/// Decodes the raw `runJavaScriptReturningResult` value of
/// [buildGenerateTokenJs] into `{status, body, cookieNames}`.
///
/// The WebView bridge returns a JSON-encoded string, so [raw] may need one
/// or two `jsonDecode` passes before yielding
/// `{status: int, body: String, cookieNames: List<String>}`.
/// Returns null on any shape/status failure. `cookieNames` defaults to `[]`
/// when absent (older bridge shape); entries are sanitized to names only
/// (split on '=', trim, drop empties) so cookie values can never leak.
///
/// Kept for the legacy return-value bridge; the channel bridge
/// ([parseMintChannelMessage]) is preferred because `runJavaScriptReturningResult`
/// serializes the unsettled `Promise` of an async IIFE instead of awaiting it.
MintJsResult? parseMintJsResult2(String raw) {
  try {
    return _parseMintDecoded(jsonDecode(raw));
  } catch (_) {
    return null;
  }
}

/// Decodes a `SsoMint` JavaScriptChannel message into
/// `{status, body, cookieNames}`.
///
/// Channel messages arrive as a raw (single-encoded) JSON string, NOT the
/// double-encoded value `runJavaScriptReturningResult` produces — so [message]
/// needs a single `jsonDecode` before the shared core (which still tolerates
/// one legacy extra layer). Returns null on any shape failure.
/// Values are never logged.
MintJsResult? parseMintChannelMessage(String message) {
  if (message.isEmpty) return null;
  try {
    return _parseMintDecoded(jsonDecode(message));
  } catch (_) {
    return null;
  }
}

/// Decodes the raw `runJavaScriptReturningResult` value of
/// [buildGenerateTokenJs] into a token.
///
/// Delegates to [parseMintJsResult2] for bridge decoding, then applies the
/// strict [parseMintResult] validator. Returns null on any shape/status
/// failure. Never logs or returns the token value itself (callers log
/// lengths only).
String? parseMintJsResult(String raw) {
  final r = parseMintJsResult2(raw);
  if (r == null) return null;
  return parseMintResult(r.status, r.body);
}

/// JS statement (NOT an expression) that POSTs
/// `/api/profile/generate_auth_token/` and delivers the settled result via
/// the `SsoMint` JavaScriptChannel.
///
/// A `return` value must NOT be relied on here: an async IIFE returns a
/// `Promise` and `runJavaScriptReturningResult` serializes the unsettled
/// promise object instead of awaiting settlement, so the mint result is never
/// readable that way (live failure: resolves in ~27ms with an unparseable
/// value on every attempt). Fire-and-forget this with `runJavaScript` and
/// read the result from the channel.
String buildGenerateTokenJs() => '''
(async () => {
  try {
    const m = document.cookie.match(/(?:^|; )csrftoken=([^;]*)/);
    const r = await fetch('/api/profile/generate_auth_token/', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {'Content-Type': 'application/json', ...(m ? {'X-CSRFToken': decodeURIComponent(m[1])} : {})},
    });
    const cookieNames = document.cookie.split(';').map(s=>s.split('=')[0].trim());
    SsoMint.postMessage(JSON.stringify({status: r.status, body: await r.text(), cookieNames}));
  } catch (e) {
    try { SsoMint.postMessage(JSON.stringify({status: 0, body: '', cookieNames: []})); } catch (_) {}
  }
})()
''';
