import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/core/security/session_manager_impl.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/oidc/cubit/oidc_cubit.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/oidc/service/appauth_oidc_facade.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';

class OidcLoginButton extends StatelessWidget {
  final String serverUrl;
  final List<OidcProvider> providers;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;
  final bool forceVisibleForTest;
  const OidcLoginButton({
    super.key,
    required this.serverUrl,
    required this.providers,
    this.clientCertificate,
    this.additionalHeaders,
    this.forceVisibleForTest = false,
  });

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty && !forceVisibleForTest) {
      return const SizedBox.shrink();
    }
    return BlocProvider(
      create: (_) => OidcCubit(
        OidcApi(SessionManagerImpl().client),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message}\nIf your IdP requires a client secret, use an API key instead.',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final busy = state is OidcExchanging;
          return Column(
            children: [
              FilledButton.tonalIcon(
                onPressed: busy
                    ? null
                    : () => context.read<OidcCubit>().start(providers.first),
                icon: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.key),
                label: const Text('Continue with SSO'),
              ),
              if (state is OidcOtpRequired)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Authenticator code (SSO second factor)',
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
