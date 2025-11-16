import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/dialogs/select_file_type_dialog.dart';
import 'package:paperless_mobile/features/settings/model/file_download_type.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DocumentShareButton extends StatefulWidget {
  final Document? document;
  final bool enabled;
  const DocumentShareButton({
    super.key,
    required this.document,
    this.enabled = true,
  });

  @override
  State<DocumentShareButton> createState() => _DocumentShareButtonState();
}

class _DocumentShareButtonState extends State<DocumentShareButton> {
  bool _isDownloadPending = false;

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareActionWrapper(
      offlineBuilder: (context, child) =>
          const IconButton(icon: Icon(Icons.share), onPressed: null),
      child: IconButton(
        tooltip: S.of(context)!.shareTooltip,
        icon: _isDownloadPending
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              )
            : const Icon(Icons.share),
        onPressed: widget.document != null && widget.enabled
            ? () => _onShare(widget.document!)
            : null,
      ).paddedOnly(right: 4),
    );
  }

  Future<void> _onShare(Document document) async {
    try {
      final localStore = context.read<LocalStore>();
      final globalSettings = localStore.state.globalSettings;
      bool original;

      switch (globalSettings.defaultShareType) {
        case FileDownloadType.original:
          original = true;
          break;
        case FileDownloadType.archived:
          original = false;
          break;
        case FileDownloadType.alwaysAsk:
          final isOriginal = await showDialog<bool>(
            context: context,
            builder: (context) => SelectFileTypeDialog(
              onRememberSelection: (downloadType) {
                localStore.updateGlobalSettings(
                  globalSettings.copyWith(defaultShareType: downloadType),
                );
              },
            ),
          );
          if (isOriginal == null) {
            return;
          } else {
            original = isOriginal;
          }
          break;
      }

      if (Platform.isAndroid && androidInfo!.version.sdkInt < 30) {
        final isGranted = await askForPermission(Permission.storage);
        if (!isGranted) {
          return;
        }
      }
      setState(() => _isDownloadPending = true);
      if (mounted) {
        await context.read<DocumentDetailsCubit>().shareDocument(
          shareOriginal: original,
        );
      }
    } on PaperlessApiException catch (error, stackTrace) {
      if (mounted) showErrorMessage(context, error, stackTrace);
    } catch (error) {
      if (mounted) showGenericError(context, error);
    } finally {
      if (mounted) setState(() => _isDownloadPending = false);
    }
  }
}
