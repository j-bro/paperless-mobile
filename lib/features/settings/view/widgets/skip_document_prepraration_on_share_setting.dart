import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SkipDocumentPreprationOnShareSetting extends StatelessWidget {
  const SkipDocumentPreprationOnShareSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.globalSettings$;
    return SwitchListTile(
      title: Text(S.of(context)!.skipEditingReceivedFiles),
      subtitle: Text(S.of(context)!.uploadWithoutPromptingUploadForm),
      value: settings.skipDocumentPreprarationOnUpload,
      onChanged: (value) {
        context.localStore.updateGlobalSettings(
          (state) => state.copyWith(skipDocumentPreprarationOnUpload: value),
        );
      },
    );
  }
}
