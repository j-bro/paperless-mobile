import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/web_session_token_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView-session SSO fallback login page (Task 8).
///
/// Used when capability detection classifies the server as [webFallback]:
/// the server has no allauth headless JSON + public-client data, but its
/// login page lists OIDC providers (e.g. paperless-ngx v2.x + Authentik).
/// The user completes SSO inside this WebView; once the page leaves
/// `/accounts/` (active server session) we `POST
/// /api/profile/generate_auth_token/` via the JS fetch bridge and pop the
/// resulting DRF token back to the caller.
///
/// Security rules (global OIDC constraints):
/// - The WebView loads ONLY `serverUrl`-origin pages initially. IdP
///   redirects arise from the server's own login links; there is deliberately
///   no URL bar so the user cannot navigate to arbitrary origins.
/// - The token travels via the `SsoMint` JavaScriptChannel only. Never log
///   page HTML, cookies, or the token. (`runJavaScriptReturningResult` must
///   NOT be relied on: it serializes the unsettled `Promise` of the async
///   mint IIFE instead of awaiting it, so the mint result is never readable
///   that way.)
/// - `JavaScriptMode.unrestricted` is REQUIRED for the fetch bridge below;
///   without it the token exchange cannot run in-page.
class SsoWebLoginPage extends StatefulWidget {
  final String serverUrl;
  final List<OidcProvider> providers;

  const SsoWebLoginPage({
    super.key,
    required this.serverUrl,
    this.providers = const [],
  });

  @override
  State<SsoWebLoginPage> createState() => _SsoWebLoginPageState();
}

class _SsoWebLoginPageState extends State<SsoWebLoginPage> {
  late final WebViewController _controller;
  bool _busy = false;
  String? _error;

  /// Per-attempt mint bridge: the channel handler completes the current
  /// attempt's completer; late/duplicate messages after pop/timeout are
  /// ignored via the attempt id + `Completer.isCompleted` guard.
  int _mintAttempt = 0;
  Completer<MintJsResult?>? _mintCompleter;
  int _mintCompleterAttempt = 0;

  @override
  void initState() {
    super.initState();
    // JavaScriptMode.unrestricted is required for the fetch bridge
    // (see class docs); the bridge only POSTs to the server origin.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SsoMint',
        onMessageReceived: _onMintMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => _maybeFinish(url),
          onWebResourceError: (error) => _onLoadError(),
        ),
      )
      ..loadRequest(buildSsoLoginUrl(widget.serverUrl));
  }

  /// Channel entry point: completes the current attempt only. Late messages
  /// (after pop/timeout/superseding attempt) and duplicates are dropped.
  void _onMintMessage(JavaScriptMessage message) {
    final completer = _mintCompleter;
    if (completer == null || completer.isCompleted) return;
    if (_mintCompleterAttempt != _mintAttempt) return;
    completer.complete(parseMintChannelMessage(message.message));
  }

  void _onLoadError() {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = S.of(context)!.ssoPageLoadFailed;
    });
  }

  void _setTokenFailed([int? status]) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      final s = S.of(context)!;
      _error = status == null ? s.ssoTokenFailed : s.ssoTokenFailedWithStatus(status);
    });
  }

  Future<void> _maybeFinish(String url) async {
    if (!isSsoSessionActive(url, widget.serverUrl) || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    // New mint attempt: the channel handler below completes this completer.
    _mintAttempt++;
    final attempt = _mintAttempt;
    final completer = _mintCompleter = Completer<MintJsResult?>();
    _mintCompleterAttempt = attempt;
    try {
      // Log host only — never url query, html, cookies, or token value.
      final host = Uri.tryParse(url)?.host ?? 'unknown';
      logger.fd(
        'SSO WebView session active on host $host; minting token.',
        className: runtimeType.toString(),
        methodName: '_maybeFinish',
      );
      // Token via SsoMint channel only; fire-and-forget (the JS is a
      // statement that posts the settled result — its return value, an
      // unsettled Promise, is meaningless). Never log cookie values, HTML,
      // page URL query, or the token — status int + body length + cookie
      // names only.
      unawaited(
        _controller.runJavaScript(buildGenerateTokenJs()).catchError(
              // ignore: avoid_catches_without_on_clauses
              (_) => null,
            ),
      );
      // 20s timeout → plain mint-failure path (no status).
      final mint = await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );
      // Superseded by a newer attempt, or widget gone: drop silently.
      if (!mounted || attempt != _mintAttempt) return;
      // Detach so late/duplicate channel messages are ignored.
      if (identical(_mintCompleter, completer)) _mintCompleter = null;
      if (mint == null) {
        logger.fw(
          'SSO mint timed out or bridge delivered no result.',
          className: runtimeType.toString(),
          methodName: '_maybeFinish',
        );
        _setTokenFailed();
        return;
      }
      final status = mint.status;
      logger.fd(
        'SSO mint HTTP status $status.',
        className: runtimeType.toString(),
        methodName: '_maybeFinish',
      );
      logger.fd(
        'SSO mint diagnostics: body length ${mint.body.length}, '
        'cookies: ${mint.cookieNames.join(',')}.',
        className: runtimeType.toString(),
        methodName: '_maybeFinish',
      );
      final token = parseMintResult(mint.status, mint.body);
      if (!mounted) return;
      if (token != null) {
        logger.fi(
          'SSO mint succeeded (token length ${token.length}).',
          className: runtimeType.toString(),
          methodName: '_maybeFinish',
        );
        // Invalidate so late/duplicate channel messages are ignored.
        _mintAttempt++;
        _mintCompleter = null;
        Navigator.of(context).pop(token);
        return;
      }
      logger.fw(
        'SSO mint failed: status $status, '
        'body length ${mint.body.length}, '
        'cookies: ${mint.cookieNames.join(',')}.',
        className: runtimeType.toString(),
        methodName: '_maybeFinish',
      );
      _setTokenFailed(status);
    } catch (_) {
      if (identical(_mintCompleter, completer)) _mintCompleter = null;
      _setTokenFailed();
    }
  }

  /// Help text that surfaces the available IdP provider names when known,
  /// so the `providers` constructor param is actually used.
  String _helpText(BuildContext context) {
    final base = S.of(context)!.ssoWebLoginHelp;
    if (widget.providers.isEmpty) return base;
    final names = widget.providers.map((p) => p.name).join(', ');
    return '$base\n$names';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.ssoLoginInBrowser),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_busy) const Center(child: CircularProgressIndicator()),
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _helpText(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (_error != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
