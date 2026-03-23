import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/global_settings_builder.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class EnforcePdfUploadSetting extends StatelessWidget {
  const EnforcePdfUploadSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localStore = context.localStore;
    return GlobalSettingsBuilder(
      builder: (context, settings) => SwitchListTile(
        title: Text(S.of(context)!.uploadScansAsPdf),
        subtitle: Text(S.of(context)!.convertSinglePageScanToPdf),
        value: settings.enforceSinglePagePdfUpload,
        onChanged: (value) {
          localStore.updateGlobalSettings(
            (state) => state.copyWith(enforceSinglePagePdfUpload: value),
          );
        },
      ),
    );
  }
}
