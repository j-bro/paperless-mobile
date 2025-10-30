import 'dart:typed_data';

import 'package:paperless_api/generated/lib/src/model/bulk_download.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_download_request.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_edit_documents_result.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_edit_request.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/document_request.dart';
import 'package:paperless_api/generated/lib/src/model/metadata.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_document_list.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_log_entry_list.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_notes_list.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_request.dart';
import 'package:paperless_api/generated/lib/src/model/selection_data.dart';
import 'package:paperless_api/generated/lib/src/model/share_link.dart';
import 'package:paperless_api/generated/lib/src/model/suggestions.dart';
import 'package:paperless_api/src/models/request/document_filter_options.dart';

abstract class PaperlessDocumentsApi {
  Future<String?> create(
    Uint8List documentBytes, {
    required String filename,
    String? title,
    DateTime? createdAt,
    int? documentType,
    int? correspondent,
    int? storagePath,
    Iterable<int> customFields = const [],
    Iterable<int> tags = const [],
    int? archiveSerialNumber,
    void Function(double progress)? onProgressChanged,
  });
  Future<PaginatedDocumentList> getAll([DocumentFilterOptions? options]);
  Future<Document> get(int id, {bool? fullPerms, List<String>? fields});
  Future<Document> put(int id, DocumentRequest document);
  Future<Document> patch(int id, PatchedDocumentRequest document);
  Future<void> delete(int id);
  Future<Metadata> getMetaData(int id);
  Future<PaginatedLogEntryList> getLogs(int id, {int? page, int? pageSize});
  Future<PaginatedNotesList> getNotes(int id, {int? page, int? pageSize});
  Future<PaginatedNotesList> addNote(int documentId, String note);
  Future<PaginatedNotesList> deleteNote(int documentId, int noteId);
  String getPreviewUrl(int id);
  Future<Uint8List> getPreview(int documentId);
  Future<Iterable<ShareLink>> getShareLinks(int documentId);
  Future<Suggestions> getFieldSuggestions(int documentId);
  String getThumbnailUrl(int documentId);
  Future<BulkDownload> bulkDownload(BulkDownloadRequest request);
  Future<BulkEditDocumentsResult> bulkEditDocuments(BulkEditRequest request);
  Future<int> getNextAsn();
  Future<Iterable<int>> bulkAction(BulkEditRequest action);
  Future<SelectionData> getSelectionData(Iterable<int> documentIds);
  Future<Uint8List> downloadDocument(int id, {bool original});

  Future<void> downloadToFile(
    int id,
    String localFilePath, {
    bool original = false,
    void Function(double progress)? onProgressChanged,
  });
}
