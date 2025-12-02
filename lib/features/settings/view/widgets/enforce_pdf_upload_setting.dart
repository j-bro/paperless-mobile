import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class EnforcePdfUploadSetting extends StatelessWidget {
  const EnforcePdfUploadSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.globalSettings$;
    return SwitchListTile(
      title: Text(S.of(context)!.uploadScansAsPdf),
      subtitle: Text(S.of(context)!.convertSinglePageScanToPdf),
      value: settings.enforceSinglePagePdfUpload,
      onChanged: (value) {
        context.localStore.updateGlobalSettings(
          (state) => state.copyWith(enforceSinglePagePdfUpload: value),
        );
      },
    );
  }
}
