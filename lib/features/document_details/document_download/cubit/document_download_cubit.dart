import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:path/path.dart' as p;

part 'document_download_state.dart';

class DocumentDownloadCubit extends Cubit<DocumentDownloadState> {
  final int documentId;
  final DocumentRepository _documentRepository;
  final PaperlessDocumentsApi _documentsApi;
  final LocalNotificationService _notificationService;

  DocumentDownloadCubit(
    this._documentRepository,
    this._documentsApi,
    this._notificationService, {
    required this.documentId,
  }) : super(DocumentDownloadInitial());

  Future<void> downloadDocument({
    bool downloadOriginal = false,
    required String locale,
    required String userId,
  }) async {
    emit(DocumentDownloadInProgress(0.0));
    try {
      final targetPath = await _documentRepository.generateLocalFilePath(
        documentId,
        original: downloadOriginal,
      );
      if (!await File(targetPath).exists()) {
        await File(targetPath).create();
      } else {
        await _notificationService.notifyDocumentDownload(
          documentId: documentId,
          filename: p.basename(targetPath),
          filePath: targetPath,
          finished: true,
          locale: locale,
          userId: userId,
        );
      }
      // await _notificationService.notifyFileDownload(
      //   document: state.document,
      //   filename: p.basename(targetPath),
      //   filePath: targetPath,
      //   finished: false,
      //   locale: locale,
      //   userId: userId,
      // );
      await _documentsApi.downloadToFile(
        documentId,
        targetPath,
        original: downloadOriginal,
        onProgressChanged: (progress) {
          emit(DocumentDownloadInProgress(progress));
          _notificationService.notifyDocumentDownload(
            documentId: documentId,
            filename: p.basename(targetPath),
            filePath: targetPath,
            finished: true,
            locale: locale,
            userId: userId,
            progress: progress,
          );
        },
      );
      await _notificationService.notifyDocumentDownload(
        documentId: documentId,
        filename: p.basename(targetPath),
        filePath: targetPath,
        finished: true,
        locale: locale,
        userId: userId,
      );
      logger.fi("Document '$documentId' saved to $targetPath.");
    } catch (error) {
      emit(DocumentDownloadError(error));
    }
  }
}
