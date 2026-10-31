import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/core/interceptor/persistent_logging_interceptor.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_cubit.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/appauth_oidc_facade.dart';
import 'package:paperless_mobile/features/login/oidc/service/interrupted_sso_store.dart';
import 'package:paperless_mobile/features/login/oidc/view/sso_web_login_page.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';

class OidcLoginButton extends StatelessWidget {
  final String serverUrl;
  final List<OidcProvider> providers;
  final OidcFlow flow;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;
  final bool forceVisibleForTest;

  /// Test seam for the WebView fallback entry point: production code pushes
  /// [SsoWebLoginPage] and awaits the `String?` token result. Tests inject a
  /// fake here to avoid instantiating a platform WebView.
  final Future<String?> Function(BuildContext context)? openWebSsoPage;
  const OidcLoginButton({
    super.key,
    required this.serverUrl,
    required this.providers,
    this.flow = OidcFlow.direct,
    this.clientCertificate,
    this.additionalHeaders,
    this.forceVisibleForTest = false,
    this.openWebSsoPage,
  });

  Future<String?> _defaultOpenWebSso(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) =>
            SsoWebLoginPage(serverUrl: serverUrl, providers: providers),
      ),
    );
  }

  Future<void> _openWebFallback(BuildContext context) async {
    final runner = openWebSsoPage ?? _defaultOpenWebSso;
    // Persist so a process death mid-flow can resume (see
    // resumeInterruptedSso); cleared below on every outcome.
    await _markAttempt(providers.first);
    if (!context.mounted) return;
    final token = await runner(context);
    await _clearAttempt();
    if (!context.mounted || token == null) {
      logger.fd(
        'SSO web fallback returned no token (cancelled or mint failed).',
        className: runtimeType.toString(),
        methodName: '_openWebFallback',
      );
      return;
    }
    // Log length only — never the token value.
    logger.fi(
      'SSO web fallback returned token (length ${token.length}).',
      className: runtimeType.toString(),
      methodName: '_openWebFallback',
    );
    AddUserRoute(
      serverUrl: serverUrl,
      $extra: AddUserRouteExtra(
        token: token,
        clientCertificate: clientCertificate,
        additionalHeaders: additionalHeaders,
      ),
    ).replace(context);
  }

  /// Best-effort persistence of the in-flight attempt: if the OS kills
  /// the app during the browser round-trip, the next cold start resumes
  /// instead of stranding the user. Never throws.
  Future<void> _markAttempt(OidcProvider provider) async {
    try {
      await (await InterruptedSsoStore.load()).save(
        InterruptedSsoAttempt(
          serverUrl: serverUrl,
          provider: provider,
          startedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Persistence must never break login itself.
    }
  }

  Future<void> _clearAttempt() async {
    try {
      await (await InterruptedSsoStore.load()).clear();
    } catch (_) {
      // Best-effort only.
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((flow == OidcFlow.none || providers.isEmpty) &&
        !forceVisibleForTest) {
      return const SizedBox.shrink();
    }
    return BlocProvider(
      // Fresh server-scoped Dio: the token exchange runs before any session
      // exists, so it must not depend on the shared SessionManager client
      // (wrong baseUrl, auth headers, offline/retry interceptors).
      // PersistentLoggingInterceptor only logs method+path+status (never
      // bodies/headers), so tokens stay out of the logs.
      create: (_) => OidcCubit(
        OidcApi(
          Dio(BaseOptions(baseUrl: serverUrl))
            ..interceptors.add(PersistentLoggingInterceptor()),
        ),
        AppAuthOidcFacade(),
      ),
      child: BlocConsumer<OidcCubit, OidcState>(
        listener: (context, state) async {
          if (state is OidcSuccess) {
            await _clearAttempt();
            if (!context.mounted) return;
            AddUserRoute(
              serverUrl: serverUrl,
              $extra: AddUserRouteExtra(
                token: state.drfToken,
                clientCertificate: clientCertificate,
                additionalHeaders: additionalHeaders,
              ),
            ).replace(context);
          } else if (state is OidcError) {
            await _clearAttempt();
            if (!context.mounted) return;
            final l10n = S.of(context)!;
            final message =
                state.canRetry ? state.message : l10n.ssoAccountNotLinked;
            // The system-browser round-trip is fragile (browser handoff
            // gates, background kills): always offer the in-process
            // fallback flow, which needs no round-trip, as the next step.
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$message\n${l10n.ssoSecretRequiredFallback}',
                ),
                action: SnackBarAction(
                  label: l10n.useInAppLogin,
                  onPressed: () {
                    if (context.mounted) _openWebFallback(context);
                  },
                ),
              ),
            );
          } else if (state is OidcCancelled) {
            await _clearAttempt();
          }
        },
        builder: (context, state) {
          final busy = state is OidcExchanging;
          // Direct flow uses the AppAuth system-browser cubit; webFallback
          // pushes the WebView-session page and forwards its token result.
          final onPressed = busy
              ? null
              : flow == OidcFlow.direct
                  ? () async {
                      logger.fi(
                        'SSO button tapped (direct flow, provider ${providers.first.id}).',
                        className: runtimeType.toString(),
                        methodName: 'build',
                      );
                      // Persist before leaving the app; cleared on outcome.
                      await _markAttempt(providers.first);
                      if (!context.mounted) return;
                      context.read<OidcCubit>().start(providers.first);
                    }
                  : () => _openWebFallback(context);
          return Column(
            children: [
              FilledButton.tonalIcon(
                onPressed: onPressed,
                icon: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.key),
                label: Text(
                  S.of(context)!.continueWithSso(
                    providers.isNotEmpty ? providers.first.name : 'SSO',
                  ),
                ),
              ),
              if (state is OidcOtpRequired)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: S.of(context)!.ssoSecondFactorCode,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    onSubmitted: (v) =>
                        context.read<OidcCubit>().confirmMfa(v.trim()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
