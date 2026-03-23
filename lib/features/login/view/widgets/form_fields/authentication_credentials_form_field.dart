import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/login/authenticate_user/model/authentication_credentials.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/obscured_input_text_form_field.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/server_address_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AuthenticationCredentialsFormField extends StatefulWidget {
  static const fkCredentials = 'credentials';

  final VoidCallback? onSubmitted;
  final String? initialUsername;
  final Map<String, String>? fieldErrors;
  final GlobalKey<FormBuilderState> formKey;

  const AuthenticationCredentialsFormField({
    super.key,
    required this.formKey,
    this.onSubmitted,
    this.initialUsername,
    this.fieldErrors,
  });

  @override
  State<AuthenticationCredentialsFormField> createState() =>
      _AuthenticationCredentialsFormFieldState();
}

class _AuthenticationCredentialsFormFieldState
    extends State<AuthenticationCredentialsFormField>
    with AutomaticKeepAliveClientMixin {
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String? _username;
  String? _password;
  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _username = widget.initialUsername;
  }

  bool get _apiKeyActive => _apiKey != null && _apiKey!.isNotEmpty;
  bool get _credentialsActive =>
      (_username != null && _username!.isNotEmpty) ||
      (_password != null && _password!.isNotEmpty);

  void _updateField(FormFieldState<AuthenticationCredentials?> field) {
    if (_apiKeyActive) {
      field.didChange(AuthenticationCredentials.apiKey(apiKey: _apiKey!));
    } else if (_username != null &&
        _username!.isNotEmpty &&
        _password != null &&
        _password!.isNotEmpty) {
      field.didChange(
        AuthenticationCredentials.password(
          username: _username!,
          password: _password!,
        ),
      );
    } else {
      field.didChange(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final existingUserIds = context
        .watch<LocalStore>()
        .state
        .localUserData
        .keys;
    return FormBuilderField<AuthenticationCredentials?>(
      name: AuthenticationCredentialsFormField.fkCredentials,
      validator: (value) {
        if (value == null) {
          return S.of(context)!.pleaseProvideCredentialsOrApiKey;
        }
        return null;
      },
      builder: (field) => Column(
        children: [
          AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.initialUsername,
                  key: const ValueKey('login-username'),
                  focusNode: _usernameFocusNode,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  enabled: !_apiKeyActive,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  onChanged: (username) {
                    _username = username;
                    _updateField(field);
                  },
                  validator: (value) {
                    if (_apiKeyActive) return null;
                    if (value?.trim().isEmpty ?? true) {
                      return S.of(context)!.usernameMustNotBeEmpty;
                    }
                    final serverAddress = widget.formKey.currentState
                        ?.getRawValue<String>(
                          ServerAddressFormField.fkServerAddress,
                        );
                    if (serverAddress != null) {
                      final userExists = existingUserIds.contains(
                        '$value@$serverAddress',
                      );
                      if (userExists) {
                        return S.of(context)!.userAlreadyExists;
                      }
                    }
                    return null;
                  },
                  autofillHints: const [AutofillHints.username],
                  decoration: InputDecoration(
                    label: Text(S.of(context)!.username),
                    errorText: widget.fieldErrors?['username'],
                  ),
                ).padded(),
                ObscuredInputTextFormField(
                  key: const ValueKey('login-password'),
                  focusNode: _passwordFocusNode,
                  enabled: !_apiKeyActive,
                  label: S.of(context)!.password,
                  onChanged: (password) {
                    _password = password;
                    _updateField(field);
                  },
                  errorText: widget.fieldErrors?['password'],
                  onFieldSubmitted: (_) {
                    if (!_apiKeyActive) widget.onSubmitted?.call();
                  },
                  validator: (value) {
                    if (_apiKeyActive) return null;
                    if (!_credentialsActive) return null;
                    if (value?.trim().isEmpty ?? true) {
                      return S.of(context)!.passwordMustNotBeEmpty;
                    }
                    return null;
                  },
                ).padded(),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(child: Divider(indent: 24, endIndent: 16, height: 24)),
              Text('OR'),
              Flexible(child: Divider(indent: 16, endIndent: 24, height: 24)),
            ],
          ),
          ObscuredInputTextFormField(
            key: const ValueKey('login-api-key'),
            enabled: !_credentialsActive,
            label: S.of(context)!.apiKey,
            onChanged: (apiKey) {
              _apiKey = apiKey;
              _updateField(field);
            },
            errorText: widget.fieldErrors?['apiKey'],
            onFieldSubmitted: (_) {
              if (_apiKeyActive) widget.onSubmitted?.call();
            },
            validator: (value) {
              if (_credentialsActive) return null;
              if (!_apiKeyActive) return null;
              if (value?.trim().isEmpty ?? true) {
                return S.of(context)!.apiKeyMustNotBeEmpty;
              }
              return null;
            },
          ).padded(),
          if (field.hasError && field.errorText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                field.errorText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
