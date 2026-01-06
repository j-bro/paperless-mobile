import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/widgets/app_logs_footer_widget.dart';
import 'package:paperless_mobile/features/login/authenticate_user/cubit/authenticate_user_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/user_credentials_form_field.dart';
import 'package:paperless_mobile/generated/assets.gen.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';

class AuthenticateUserPage extends StatefulWidget {
  final String serverUrl;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;
  final String? initialUsername;
  final String? initialPassword;

  const AuthenticateUserPage({
    super.key,
    required this.serverUrl,
    this.initialUsername,
    this.initialPassword,
    this.clientCertificate,
    this.additionalHeaders,
  });
  @override
  State<AuthenticateUserPage> createState() => _AuthenticateUserPageState();
}

class _AuthenticateUserPageState extends State<AuthenticateUserPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticateUserCubit, AuthenticateUserState>(
      listener: (context, state) {
        switch (state) {
          case AuthenticateUserError error:
            if (error.nonFieldError != null) {
              showLocalizedError(context, error.nonFieldError!);
              break;
            }
            showGenericError(context, error);
            break;
          case AuthenticateUserSuccess(
            :final serverUrl,
            :final username,
            :final token,
            :final clientCertificate,
          ):
            SetActiveUserRoute(
              serverUrl: serverUrl,
              username: username,
              token: token,
              $extra: clientCertificate,
            ).go(context);
            break;
          case AuthenticateUserOtpRequired(
            :final serverUrl,
            :final username,
            :final password,
            :final clientCertificate,
          ):
            OtpRoute(
              serverUrl: serverUrl,
              username: username,
              password: password,
              $extra: clientCertificate,
            ).push(context);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        persistentFooterButtons: [AppLogsFooterWidget().padded()],
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterDecoration: BoxDecoration(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(S.of(context)!.connectToPaperless),
          leading: BackButton(
            onPressed: () => {
              AuthRoute(
                initialHost: widget.serverUrl,
                $extra: AuthRouteExtra(
                  clientCertificate: widget.clientCertificate,
                  additionalHeaders: widget.additionalHeaders,
                ),
              ).go(context),
            },
          ),
        ),
        body: FormBuilder(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.logos.paperlessLogoGreenPng.image(
                  width: 150,
                  height: 150,
                ),
                Text(
                  'Paperless Mobile',
                  style: Theme.of(context).textTheme.displaySmall,
                ).padded(),
                SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      UserCredentialsFormField(
                        formKey: _formKey,
                        initialUsername: widget.initialUsername,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text(S.of(context)!.edit),
                          ),
                          _buildSubmitButton(),
                        ],
                      ).padded(),
                      Text(
                        S.of(context)!.loginRequiredPermissionsHint,
                        style: Theme.of(context).textTheme.bodySmall?.apply(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(153),
                        ),
                      ).padded(16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthenticateUserCubit, AuthenticateUserState>(
      builder: (context, state) {
        return switch (state) {
          AuthenticateUserChecking() => FilledButton.icon(
            onPressed: null,
            label: Text(S.of(context)!.signIn),
            icon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          ),
          _ => FilledButton(
            onPressed: _onSubmit,
            child: Text(S.of(context)!.signIn),
          ),
        };
      },
    );
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final form = _formKey.currentState!.value;
      final credentials =
          form[UserCredentialsFormField.fkCredentials] as LoginFormCredentials;

      context.read<AuthenticateUserCubit>().login(
        serverUrl: widget.serverUrl,
        // We can safely enforce non-null here since the validation already took care of it
        username: credentials.username!,
        password: credentials.password!,
      );
    }
  }
}
