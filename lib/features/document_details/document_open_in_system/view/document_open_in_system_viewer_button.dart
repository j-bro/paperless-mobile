import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/document_details/document_open_in_system/cubit/document_open_in_system_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentOpenInSystemViewerButton extends StatelessWidget {
  const DocumentOpenInSystemViewerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentOpenInSystemCubit, DocumentOpenInSystemState>(
      builder: (context, state) {
        return IconButton(
          tooltip: S.of(context)!.openInSystemViewer,
          icon: switch (state) {
            DocumentOpenInSystemInProgress(:final progress) => SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(value: progress),
            ),
            _ => const Icon(Icons.open_in_new),
          },
          onPressed: state is DocumentOpenInSystemInProgress
              ? null
              : () => context
                    .read<DocumentOpenInSystemCubit>()
                    .openDocumentInSystemViewer(),
        );
      },
      listener: (context, state) {
        switch (state) {
          case DocumentOpenInSystemSuccess(:final resultType):
            switch (resultType) {
              case ResultType.noAppToOpen:
                if (context.mounted) {
                  showGenericError(
                    context,
                    S.of(context)!.noAppToDisplayPDFFilesFound,
                  );
                }
              case ResultType.fileNotFound:
                showErrorMessage(
                  context,
                  PaperlessApiException(ErrorCode.unknown),
                );
                break;
              case ResultType.permissionDenied:
                showGenericError(
                  context,
                  S.of(context)!.couldNotOpenFilePermissionDenied,
                );
                break;
              default:
                break;
            }
            break;
          case DocumentOpenInSystemError():
            showGenericError(
              context,
              S.of(context)!.noAppToDisplayPDFFilesFound,
            );
          default:
            break;
        }
      },
    );
  }
}
