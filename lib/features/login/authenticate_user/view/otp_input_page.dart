import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/login/authenticate_user/cubit/authenticate_user_cubit.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';
import 'package:pinput/pinput.dart';

class OtpInputPage extends StatefulWidget {
  final String serverUrl;
  final String username;
  final String password;

  final ClientCertificate? clientCertificate;
  const OtpInputPage({
    super.key,
    required this.serverUrl,
    required this.username,
    required this.password,
    this.clientCertificate,
  });

  @override
  State<OtpInputPage> createState() => _OtpInputPageState();
}

class _OtpInputPageState extends State<OtpInputPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 64,
      width: 44,
      textStyle: Theme.of(context).textTheme.titleMedium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
          bottom: Radius.circular(32),
        ),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );

    return BlocListener<AuthenticateUserCubit, AuthenticateUserState>(
      listener: (context, state) {
        switch (state) {
          case AuthenticateUserError error:
            if (error.nonFieldError != null) {
              showSnackBar(context, error.nonFieldError!);
              break;
            } else if (error.fieldErrors != null) {
              final fieldError = error.fieldErrors!['code'];
              if (fieldError != null) {
                _formKey.currentState?.fields['code']?.invalidate(
                  fieldError,
                  shouldFocus: false,
                );
              }
            } else {
              showGenericError(context, error.genericError);
            }
            break;
          case AuthenticateUserSuccess state:
            SetActiveUserRoute(
              serverUrl: state.serverUrl,
              username: state.username,
              token: state.token,
              $extra: state.clientCertificate,
            ).go(context);
            break;
          default:
            break;
        }
      },
      child: FormBuilder(
        key: _formKey,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
            appBar: AppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  S.of(context)!.mfaFormFieldHint,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                AutofillGroup(
                  child: FormBuilderField<String>(
                    name: 'code',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context)!.mfaCodeRequiredValidationMessage;
                      }
                      if (value.length != 6) {
                        return S
                            .of(context)!
                            .mfaCodeInvalidLengthValidationMessage;
                      }
                      return null;
                    },
                    builder: (field) {
                      return Pinput(
                        autofocus: true,
                        showCursor: false,
                        length: 6,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                          textStyle: defaultPinTheme.textStyle?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        defaultPinTheme: defaultPinTheme,
                        onCompleted: (value) {
                          _onSubmit();
                        },
                        errorText: field.errorText,
                        onChanged: (value) {
                          field.didChange(value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ).padded(16),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final code = _formKey.currentState?.value['code'] as String;

      context.read<AuthenticateUserCubit>().login(
        serverUrl: widget.serverUrl,
        username: widget.username,
        password: widget.password,
        otp: code,
        clientCertificate: widget.clientCertificate,
      );
    }
  }
}
