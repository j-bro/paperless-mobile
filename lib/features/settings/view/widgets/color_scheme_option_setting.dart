import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/global_settings_builder.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/core/translation/color_scheme_option_localization_mapper.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/view/widgets/radio_settings_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class ColorSchemeOptionSetting extends StatelessWidget {
  const ColorSchemeOptionSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localStore = context.localStore;
    return GlobalSettingsBuilder(
      builder: (context, settings) => ListTile(
        title: Text(S.of(context)!.colors),
        subtitle: Text(
          translateColorSchemeOption(
            context,
            settings.preferredColorSchemeOption,
          ),
        ),
        onTap: () =>
            showDialog<ColorSchemeOption>(
              useRootNavigator: false,
              context: context,
              builder: (_) => RadioSettingsDialog<ColorSchemeOption>(
                titleText: S.of(context)!.colors,
                descriptionText: S.of(context)!.colorSchemeHint,
                options: [
                  RadioOption(
                    value: ColorSchemeOption.classic,
                    label: translateColorSchemeOption(
                      context,
                      ColorSchemeOption.classic,
                    ),
                  ),
                  RadioOption(
                    value: ColorSchemeOption.dynamic,
                    label: translateColorSchemeOption(
                      context,
                      ColorSchemeOption.dynamic,
                    ),
                  ),
                ],
                footer: _isBelowAndroid12()
                    ? HintCard(
                        hintText: S.of(context)!.colorSchemeNotSupportedWarning,
                        hintIcon: Icons.warning_amber,
                      )
                    : null,
                initialValue: settings.preferredColorSchemeOption,
              ),
            ).then((value) async {
              if (value == null) {
                return;
              }
              localStore.updateGlobalSettings(
                (state) => state.copyWith(preferredColorSchemeOption: value),
              );
            }),
      ),
    );
  }

  bool _isBelowAndroid12() {
    if (Platform.isAndroid) {
      final int version = int.tryParse(androidInfo!.version.release) ?? 0;
      return version < 12;
    }
    return false;
  }
}
