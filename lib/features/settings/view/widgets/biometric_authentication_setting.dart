import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BiometricAuthenticationSetting extends StatelessWidget {
  const BiometricAuthenticationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.loggedInUserData$;
    return SwitchListTile(
      value: account.isBiometricAuthenticationEnabled,
      title: Text(S.of(context)!.biometricAuthentication),
      subtitle: Text(S.of(context)!.authenticateOnAppStart),
      onChanged: (val) async {
        final String localizedReason = S
            .of(context)!
            .authenticateToToggleBiometricAuthentication(
              val ? 'enable' : 'disable',
            );

        final isAuthenticated = await context
            .read<LocalAuthenticationService>()
            .authenticateLocalUser(localizedReason);
        if (isAuthenticated) {
          context.localStore.updateUserData(
            account.userId,
            (state) => state.copyWith(isBiometricAuthenticationEnabled: val),
          );
        }
      },
    );
  }
}
