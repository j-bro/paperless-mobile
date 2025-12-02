import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';

class DisableAnimationsSetting extends StatelessWidget {
  const DisableAnimationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.globalSettings$;
    return SwitchListTile(
      value: settings.disableAnimations,
      title: Text('Disable animations'), //TODO: INTL
      subtitle: Text(
        'Disables page transitions and most animations.'
        ' Temporary workaround until system accessibility settings can be used.',
      ),
      onChanged: (val) async {
        context.localStore.updateGlobalSettings(
          (state) => state.copyWith(disableAnimations: val),
        );
      },
    );
  }
}
