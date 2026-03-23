import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/global_settings_builder.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class ThemeModeSetting extends StatelessWidget {
  const ThemeModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localStore = context.localStore;
    return GlobalSettingsBuilder(
      builder: (context, settings) => ListTile(
        title: Text(S.of(context)!.theme),
        subtitle: Text(
          _mapThemeModeToLocalizedString(settings.preferredThemeMode, context),
        ),
        onTap: () =>
            showDialog<ThemeMode>(
              useRootNavigator: false,
              context: context,
              builder: (_) => RadioSettingsDialog<ThemeMode>(
                titleText: S.of(context)!.appearance,
                initialValue: settings.preferredThemeMode,
                options: [
                  RadioOption(
                    value: ThemeMode.system,
                    label: S.of(context)!.systemTheme,
                  ),
                  RadioOption(
                    value: ThemeMode.light,
                    label: S.of(context)!.lightTheme,
                  ),
                  RadioOption(
                    value: ThemeMode.dark,
                    label: S.of(context)!.darkTheme,
                  ),
                ],
              ),
            ).then((value) async {
              if (value != null) {
                localStore.updateGlobalSettings(
                  (state) => state.copyWith(preferredThemeMode: value),
                );
              }
            }),
      ),
    );
  }

  String _mapThemeModeToLocalizedString(ThemeMode theme, BuildContext context) {
    switch (theme) {
      case ThemeMode.system:
        return S.of(context)!.system;
      case ThemeMode.light:
        return S.of(context)!.light;
      case ThemeMode.dark:
        return S.of(context)!.dark;
    }
  }
}
