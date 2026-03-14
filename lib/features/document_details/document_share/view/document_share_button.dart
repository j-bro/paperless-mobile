import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/features/document_details/view/dialogs/select_file_type_dialog.dart';
import 'package:paperless_mobile/features/document_details/document_share/cubit/document_share_cubit.dart';
import 'package:paperless_mobile/features/settings/model/file_download_type.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
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
    return ConnectivityAwareActionWrapper(
      offlineBuilder: (context, child) =>
          const IconButton(icon: Icon(Icons.share), onPressed: null),
      child: BlocConsumer<DocumentShareCubit, DocumentShareState>(
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
      ).paddedOnly(right: 4),
    );
  }

  Future<void> _onShare() async {
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
