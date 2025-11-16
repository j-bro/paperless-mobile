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
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DocumentDownloadButton extends StatefulWidget {
  final Document? document;
  final bool enabled;
  const DocumentDownloadButton({
    super.key,
    required this.document,
    this.enabled = true,
  });

  @override
  State<DocumentDownloadButton> createState() => _DocumentDownloadButtonState();
}

class _DocumentDownloadButtonState extends State<DocumentDownloadButton> {
  bool _isDownloadPending = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: S.of(context)!.downloadDocumentTooltip,
      icon: _isDownloadPending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.download),
      onPressed: widget.document != null && widget.enabled
          ? () => _onDownload(widget.document!)
          : null,
    ).paddedOnly(right: 4);
  }

  Future<void> _onDownload(Document document) async {
    try {
      final localStore = context.read<LocalStore>();
      bool original;

      switch (localStore.state.globalSettings.defaultDownloadType) {
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
                  localStore.state.globalSettings.copyWith(
                    defaultDownloadType: downloadType,
                  ),
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

      if (Platform.isAndroid && androidInfo!.version.sdkInt <= 29) {
        final isGranted = await askForPermission(Permission.storage);
        if (!isGranted) {
          return;
          //TODO: Ask user to grant permissions
        }
      }

      setState(() => _isDownloadPending = true);
      if (mounted) {
        final localStore = context.read<LocalStore>();
        final userId = localStore.state.loggedInUserId;
        await context.read<DocumentDetailsCubit>().downloadDocument(
          downloadOriginal: original,
          locale: localStore.state.globalSettings.preferredLocaleSubtag,
          userId: userId!,
        );
        // showSnackBar(context, S.of(context)!.documentSuccessfullyDownloaded);
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
