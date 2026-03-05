import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:printing/printing.dart';

part 'document_print_state.dart';

class DocumentPrintCubit extends Cubit<DocumentPrintState> {
  final int documentId;
  final DocumentRepository _documentRepository;
  final PaperlessDocumentsApi _api;
  DocumentPrintCubit(
    this._documentRepository,
    this._api, {
    required this.documentId,
  }) : super(DocumentPrintInitial());

  Future<void> printDocument() async {
    try {
      final targetPath = await _documentRepository.generateLocalFilePath(
        documentId,
      );
      final documentQueryResult = await _documentRepository
          .getDocumentQuery(documentId)
          .fetch();

      if (documentQueryResult.isError) {
        throw documentQueryResult.error;
      }
      final document = documentQueryResult.data!;
      await _api.downloadToFile(
        documentId,
        targetPath,
        original: false,
        onProgressChanged: (progress) =>
            emit(DocumentPrintInProgress(progress)),
      );
      final file = File(targetPath);
      await Printing.layoutPdf(
        name: document.title ?? '',
        onLayout: (format) => file.readAsBytesSync(),
      );
      emit(DocumentPrintSuccess());
    } catch (e) {
      emit(DocumentPrintError(e));
    }
  }
}
