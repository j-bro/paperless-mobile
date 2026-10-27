import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/features/document_details/view/dialogs/select_file_type_dialog.dart';
import 'package:paperless_mobile/features/document_details/document_share/cubit/document_share_cubit.dart';
import 'package:paperless_mobile/features/document_details/document_share/view/document_link_actions.dart';
import 'package:paperless_mobile/features/document_details/document_share/view/document_share_options_sheet.dart';
import 'package:paperless_mobile/features/settings/model/file_download_type.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentShareButton extends StatefulWidget {
  final bool enabled;
  const DocumentShareButton({super.key, this.enabled = true});

  @override
  State<DocumentShareButton> createState() => _DocumentShareButtonState();
}

class _DocumentShareButtonState extends State<DocumentShareButton> {
  @override
  Widget build(BuildContext context) {
    // NOTE: intentionally NOT wrapped in ConnectivityAwareActionWrapper.
    // Copy-details / copy-preview are pure string builds and must work
    // offline. The share-file path is gated inside _onShare instead.
    return BlocConsumer<DocumentShareCubit, DocumentShareState>(
      listener: (context, state) {
        if (state is DocumentShareError) {
          showGenericError(context, state.error);
        }
      },
      builder: (context, state) {
        return IconButton(
          tooltip: S.of(context)!.shareTooltip,
          icon: switch (state) {
            DocumentShareInProgress() => IconLoadingWidget(),
            _ => const Icon(Icons.share),
          },
          onPressed: widget.enabled ? _onShare : null,
        );
      },
    ).paddedOnly(right: 4);
  }

  Future<void> _onShare() async {
    // NOTE: read (listen:false). The $-suffixed watch variant throws when
    // called from an event handler outside of build ("tried to listen ...
    // from outside of the widget tree"), which left the button dead.
    final serverUrl = context.loggedInUser.serverUrl;
    final documentId = context.read<DocumentShareCubit>().documentId;
    if (!mounted) return;
    final option = await showModalBottomSheet<ShareOption>(
      context: context,
      builder: (ctx) => DocumentShareOptionsSheet(
        documentId: documentId,
        serverUrl: serverUrl,
        onSelected: (o) => Navigator.of(ctx).pop(o),
      ),
    );
    if (option == null || !mounted) return;
    if (option == ShareOption.copyDetails) {
      if (serverUrl.trim().isEmpty) {
        showGenericError(context, StateError('Server URL is empty'));
        return;
      }
      final url = buildDetailsUrl(serverUrl, documentId);
      try {
        await Clipboard.setData(ClipboardData(text: url));
      } catch (error) {
        if (mounted) showGenericError(context, error);
        return;
      }
      if (mounted) showSnackBar(context, S.of(context)!.linkCopiedToClipboard);
      return;
    }
    if (option == ShareOption.copyPreview) {
      if (serverUrl.trim().isEmpty) {
        showGenericError(context, StateError('Server URL is empty'));
        return;
      }
      final url = buildPreviewUrl(serverUrl, documentId);
      try {
        await Clipboard.setData(ClipboardData(text: url));
      } catch (error) {
        if (mounted) showGenericError(context, error);
        return;
      }
      if (mounted) showSnackBar(context, S.of(context)!.linkCopiedToClipboard);
      return;
    }
    if (option == ShareOption.publicShare) {
      // Task 4 placeholder: show snackbar until manager lands
      if (mounted) showSnackBar(context, 'Public share coming in PR2');
      return;
    }
    // shareFile requires network (downloads + platform share).
    final isConnected = await context
        .read<ConnectivityStatusService>()
        .isConnectedToInternet();
    if (!mounted) return;
    if (!isConnected) {
      if (mounted) {
        showSnackBar(context, S.of(context)!.youAreCurrentlyOffline);
      }
      return;
    }
    // fall through to existing share-file logic below (unchanged)
    try {
      final localStore = context.read<LocalStore>();
      final globalSettings = localStore.state.globalSettings;
      final cubit = context.read<DocumentShareCubit>();
      final original = await switch (globalSettings.defaultShareType) {
        FileDownloadType.original => Future.value(true),
        FileDownloadType.archived => Future.value(false),
        FileDownloadType.alwaysAsk => showDialog<bool>(
          useRootNavigator: false,
          context: context,
          builder: (context) => SelectFileTypeDialog(
            onRememberSelection: (downloadType) {
              localStore.updateGlobalSettings(
                (state) => state.copyWith(defaultShareType: downloadType),
              );
            },
          ),
        ),
      };

      if (original == null) {
        return;
      }

      if (Platform.isAndroid && androidInfo!.version.sdkInt < 30) {
        final isGranted = await askForPermission(Permission.storage);
        if (!isGranted) {
          return;
        }
      }
      await cubit.shareDocument(shareOriginal: original);
    } on PaperlessApiException catch (error, stackTrace) {
      if (mounted) showErrorMessage(context, error, stackTrace);
    } catch (error) {
      if (mounted) showGenericError(context, error);
    }
  }
}
