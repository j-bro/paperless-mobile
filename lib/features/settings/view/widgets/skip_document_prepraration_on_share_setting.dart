import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/global_settings_builder.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SkipDocumentPreprationOnShareSetting extends StatelessWidget {
  const SkipDocumentPreprationOnShareSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localStore = context.localStore;

    return GlobalSettingsBuilder(
      builder: (context, settings) => SwitchListTile(
        title: Text(S.of(context)!.skipEditingReceivedFiles),
        subtitle: Text(S.of(context)!.uploadWithoutPromptingUploadForm),
        value: settings.skipDocumentPreprarationOnUpload,
        onChanged: (value) {
          localStore.updateGlobalSettings(
            (state) => state.copyWith(skipDocumentPreprarationOnUpload: value),
          );
        },
      ),
    );
  }
}
