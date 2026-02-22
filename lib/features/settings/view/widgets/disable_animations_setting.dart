import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/global_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DisableAnimationsSetting extends StatelessWidget {
  const DisableAnimationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localStore = context.localStore;
    return GlobalSettingsBuilder(
      builder: (context, settings) => SwitchListTile(
        value: settings.disableAnimations,
        title: Text(S.of(context)!.disableAnimations),
        subtitle: Text(S.of(context)!.disableAnimationsDescription),
        onChanged: (val) async {
          localStore.updateGlobalSettings(
            (state) => state.copyWith(disableAnimations: val),
          );
        },
      ),
    );
  }
}
