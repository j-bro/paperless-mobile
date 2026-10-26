import 'package:flutter/material.dart';
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
/// - The token travels via the JS bridge (`runJavaScriptReturningResult`)
///   only. Never log page HTML, cookies, or the token.
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

  @override
  void initState() {
    super.initState();
    // JavaScriptMode.unrestricted is required for the fetch bridge
    // (see class docs); the bridge only POSTs to the server origin.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => _maybeFinish(url),
        ),
      )
      ..loadRequest(
        Uri.parse('${widget.serverUrl}/accounts/login/?next=/dashboard/'),
      );
  }

  Future<void> _maybeFinish(String url) async {
    if (!isSsoSessionActive(url) || _busy) return;
    setState(() => _busy = true);
    try {
      // Token via JS bridge only; never logged.
      final raw = await _controller.runJavaScriptReturningResult(
        buildGenerateTokenJs(),
      );
      final token = parseGenerateTokenResponse(raw.toString());
      if (!mounted) return;
      if (token != null) {
        Navigator.of(context).pop(token);
        return;
      }
      setState(() {
        _busy = false;
        _error = 'Could not create an API token.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Could not create an API token.';
      });
    }
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                S.of(context)!.ssoWebLoginHelp,
                textAlign: TextAlign.center,
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
