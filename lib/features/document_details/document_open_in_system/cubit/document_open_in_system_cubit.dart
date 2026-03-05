import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/service/file_service.dart';

part 'document_open_in_system_state.dart';

class DocumentOpenInSystemCubit extends Cubit<DocumentOpenInSystemState> {
  final int documentId;
  final DocumentRepository _repository;
  final PaperlessDocumentsApi _api;
  DocumentOpenInSystemCubit(
    this._repository,
    this._api, {
    required this.documentId,
  }) : super(DocumentOpenInSystemInitial());

  void openDocumentInSystemViewer() async {
    final documentResult = await _repository
        .getDocumentQuery(documentId)
        .fetch();
    if (documentResult.isError) {
      return emit(DocumentOpenInSystemError(documentResult.error));
    }

    final filePath = await _repository.generateLocalFilePath(
      documentId,
      original: true,
      type: PaperlessDirectoryType.temporary,
    );
    final file = File(filePath);
    try {
      if (!await file.exists()) {
        await file.create();
        await _api.downloadToFile(
          documentId,
          file.path,
          onProgressChanged: (progress) =>
              emit(DocumentOpenInSystemInProgress(progress)),
        );
      }
      //TODO: Some mime types are not correctly detected by lookupMimeType, e.g. yaml files
      final mimeType = lookupMimeType(filePath);
      final resultType = await OpenFile.open(
        file.path,
        type: mimeType,
      ).then((value) => value.type);
      emit(DocumentOpenInSystemSuccess(resultType));
    } catch (e) {
      emit(DocumentOpenInSystemError(e));
      return;
    }
  }
}
