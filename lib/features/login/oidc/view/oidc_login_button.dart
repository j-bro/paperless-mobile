import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_cubit.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/appauth_oidc_facade.dart';
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
  const OidcLoginButton({
    super.key,
    required this.serverUrl,
    required this.providers,
    this.flow = OidcFlow.direct,
    this.clientCertificate,
    this.additionalHeaders,
    this.forceVisibleForTest = false,
  });

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
      create: (_) => OidcCubit(
        OidcApi(Dio(BaseOptions(baseUrl: serverUrl))),
        AppAuthOidcFacade(),
      ),
      child: BlocConsumer<OidcCubit, OidcState>(
        listener: (context, state) {
          if (state is OidcSuccess) {
            AddUserRoute(
              serverUrl: serverUrl,
              $extra: AddUserRouteExtra(
                token: state.drfToken,
                clientCertificate: clientCertificate,
                additionalHeaders: additionalHeaders,
              ),
            ).replace(context);
          } else if (state is OidcError) {
            final l10n = S.of(context)!;
            final message =
                state.canRetry ? state.message : l10n.ssoAccountNotLinked;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$message\n${l10n.ssoSecretRequiredFallback}',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final busy = state is OidcExchanging;
          // WebView fallback entry point is wired in Task 8; until then the
          // button is visible but inert for webFallback.
          final onPressed = busy
              ? null
              : flow == OidcFlow.direct
                  ? () => context.read<OidcCubit>().start(providers.first)
                  : () {};
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
                label: Text(S.of(context)!.continueWithSso),
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
