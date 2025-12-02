import 'dart:typed_data';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_download.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_download_request.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_edit_documents_result.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_edit_request.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/document_request.dart';
import 'package:paperless_api/generated/lib/src/model/metadata.dart';
import 'package:paperless_api/generated/lib/src/model/note.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_document_list.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_log_entry_list.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_request.dart';
import 'package:paperless_api/generated/lib/src/model/share_link.dart';
import 'package:paperless_api/generated/lib/src/model/suggestions.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:path/path.dart' as p;

class DocumentRepository {
  final PaperlessDocumentsApi _api;
  final Set<String> _cachedDocumentQueriesToInvalidate = {};

  DocumentRepository(this._api);

  String queryKeyForFilter(DocumentFilter? filter, [String? overrideKey]) {
    if (overrideKey != null) {
      return overrideKey;
    }
    final key = filter?.copyWith(page: 1).hashCode.toString() ?? 'unset_filter';
    return 'documents/$key';
  }

  /// Gets an infinite query for documents with optional filtering.
  /// [key] is the unique key for the query, e.g. the screen where the query is executed.
  /// [filter] is an optional DocumentFilter to apply.
  InfiniteQuery<PaginatedDocumentList, int> getAllQuery({
    DocumentFilter? filter,
    String? overrideKey,
  }) {
    // Page is always set to 1 to ensure it does not alter the cache key.
    final queryKey = queryKeyForFilter(filter, overrideKey);
    return InfiniteQuery<PaginatedDocumentList, int>(
      key: queryKey,
      queryFn: (page) async {
        try {
          final response = await _api.getAll(
            (filter ?? DocumentFilter()).toDocumentFilterOptions().copyWith(
              page: page,
            ),
          );
          return response;
        } catch (e) {
          rethrow;
        }
      },
      onSuccess: (data) {
        _cachedDocumentQueriesToInvalidate.add(queryKey);
      },
      getNextArg: (state) {
        final lastPage = state?.lastPage;
        if (lastPage == null) {
          return 1;
        }
        if (lastPage.next == null) {
          return null;
        }
        return state!.args.last + 1;
      },
    );
  }

  Mutation<List<Note>, String> addNoteMutation(int documentId) {
    return Mutation<List<Note>, String>(
      key: 'add_note/$documentId',
      mutationFn: (arg) {
        return _api.addNote(documentId, arg);
      },
      onSuccess: (res, arg) {
        final documentQuery = getDocumentQuery(documentId);
        if (documentQuery.state.data != null) {
          documentQuery.update((old) => old!.copyWith(notes: res));
        }
        getAllNotesQuery(
          documentId,
        ).update((_) => InfiniteQueryData(pages: [res], args: [1]));
      },
    );
  }

  Mutation<List<Note>, void> deleteNoteMutation(int documentId, int noteId) {
    return Mutation<List<Note>, void>(
      key: 'delete_note/$documentId/$noteId',
      mutationFn: (_) {
        return _api.deleteNote(documentId, noteId);
      },
      onSuccess: (res, arg) {
        final documentQuery = getDocumentQuery(documentId);
        if (documentQuery.state.data != null) {
          documentQuery.update((old) => old!.copyWith(notes: res));
        }
        getAllNotesQuery(
          documentId,
        ).update((_) => InfiniteQueryData(pages: [res], args: [1]));
      },
      // refetchQueries: ['document_notes/$documentId'],
    );
  }

  Mutation<Iterable<int>, BulkEditRequest> bulkActionMutation() {
    return Mutation<Iterable<int>, BulkEditRequest>(
      key: 'bulk_edit_documents',
      mutationFn: (arg) {
        return _api.bulkAction(arg);
      },
      refetchQueries: [..._cachedDocumentQueriesToInvalidate],
    );
  }

  Future<BulkDownload> bulkDownload(BulkDownloadRequest request) {
    // TODO: implement bulkDownload
    throw UnimplementedError();
  }

  Mutation<int, int?> assignAsnMutation(int documentId) {
    return Mutation<int, int?>(
      key: 'assign_asn/$documentId',
      mutationFn: (asn) async {
        var nextAsn = asn;
        if (asn == null) {
          final asnResponse = await getNextAsnQuery().fetch();
          if (asnResponse.isError) {
            throw PaperlessApiException(ErrorCode.documentAsnQueryFailed);
          }
          nextAsn = asnResponse.data!;
        }
        final response = await patchDocumentMutation(
          documentId,
        ).mutate(PatchedDocumentRequest(archiveSerialNumber: nextAsn));
        if (response.isError) {
          throw PaperlessApiException(ErrorCode.documentUpdateFailed);
        }
        return response.data!.archiveSerialNumber!;
      },
      invalidateQueries: [
        'next_asn',
        'document/$documentId',
        ..._cachedDocumentQueriesToInvalidate,
      ],
    );
  }

  Mutation<BulkEditDocumentsResult, BulkEditRequest>
  bulkEditDocumentsMutation() {
    return Mutation<BulkEditDocumentsResult, BulkEditRequest>(
      key: 'bulk_edit_documents',
      mutationFn: (arg) {
        return _api.bulkEditDocuments(arg);
      },
      onSuccess: (res, arg) {
        for (final id in arg.documents) {
          final query = CachedQuery.instance.getQuery<Query<Document>>(
            'document/$id',
          );
          query?.invalidate();
        }
      },
      invalidateQueries: [_cachedDocumentQueriesToInvalidate],
    );
  }

  Mutation<String?, void> createDocumentMutation(
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
  }) {
    return Mutation<String?, void>(
      key: 'create_document/$filename',
      mutationFn: (_) {
        return _api.create(
          documentBytes,
          filename: filename,
          title: title,
          createdAt: createdAt,
          documentType: documentType,
          correspondent: correspondent,
          storagePath: storagePath,
          customFields: customFields,
          tags: tags,
          archiveSerialNumber: archiveSerialNumber,
          onProgressChanged: onProgressChanged,
        );
      },
    );
  }

  Mutation<void, void> deleteDocumentMutation(int id) {
    return Mutation<void, void>(
      key: 'delete_document/$id',
      mutationFn: (_) {
        return _api.delete(id);
      },
      invalidateQueries: [
        'document/$id',
        'field_suggestions/$id',
        ..._cachedDocumentQueriesToInvalidate,
      ],
    );
  }

  Query<Uint8List> downloadDocumentQuery(int id, {required bool original}) {
    return Query<Uint8List>(
      key: 'download_document/$id/$original',
      queryFn: () {
        return _api.downloadDocument(id, original: original);
      },
    );
  }

  Query<Document> getDocumentQuery(int id, {List<String>? fields}) {
    return Query<Document>(
      key: 'document/$id',
      queryFn: () {
        return _api.get(id, fields: fields);
      },
    );
  }

  Query<Suggestions> getFieldSuggestionsQuery(int documentId) {
    return Query(
      key: 'field_suggestions/$documentId',
      queryFn: () {
        return _api.getFieldSuggestions(documentId);
      },
    );
  }

  InfiniteQuery<PaginatedLogEntryList, int> getLogsQuery(
    int id, {
    int? pageSize,
  }) {
    return InfiniteQuery<PaginatedLogEntryList, int>(
      key: 'document_logs/$id',
      queryFn: (page) async {
        return _api.getLogs(id, page: page, pageSize: pageSize);
      },
      getNextArg: (state) {
        if (state == null) return 1;
        final currentCount = state.args.length * (pageSize ?? 20);
        final totalCount = state.lastPage?.count ?? 0;
        if (currentCount >= totalCount) {
          return null;
        }
        return state.args.last + 1;
      },
    );
  }

  Query<Metadata> getMetaDataQuery(int id) {
    return Query<Metadata>(
      key: 'document_metadata/$id',
      queryFn: () {
        return _api.getMetaData(id);
      },
    );
  }

  Query<int> getNextAsnQuery() {
    return Query(key: 'next_asn', queryFn: _api.getNextAsn);
  }

  InfiniteQuery<List<Note>, int> getAllNotesQuery(int id, {int pageSize = 20}) {
    return InfiniteQuery<List<Note>, int>(
      key: 'document_notes/$id',
      queryFn: (page) async {
        return _api.getNotes(id, page: page, pageSize: pageSize);
      },
      getNextArg: (state) {
        if (state == null) return 1;
        if (state.lastPage == null || state.lastPage!.length < pageSize) {
          return null;
        }
        return state.args.last + 1;
      },
    );
  }

  Query<Uint8List> getPreviewQuery(int documentId) {
    return Query<Uint8List>(
      key: 'document_preview/$documentId',
      queryFn: () {
        return _api.getPreview(documentId);
      },
    );
  }

  String getPreviewUrl(int id) {
    return _api.getPreviewUrl(id);
  }

  Query<Iterable<ShareLink>> getShareLinksQuery(int documentId) {
    return Query<List<ShareLink>>(
      key: 'document_share_links/$documentId',
      queryFn: () async {
        final data = await _api.getShareLinks(documentId);
        return data.toList();
      },
    );
  }

  String getThumbnailUrl(int documentId) {
    return _api.getThumbnailUrl(documentId);
  }

  Mutation<Document, PatchedDocumentRequest> patchDocumentMutation(int id) {
    return Mutation<Document, PatchedDocumentRequest>(
      key: 'patch_document/$id',
      mutationFn: (document) {
        return _api.patch(id, document);
      },
      onStartMutation: (arg) {
        final query = CachedQuery.instance.getQuery<Query<Document>>(
          'document/$id',
        );
        if (query?.state.data != null) {
          query!.update(
            (currentData) =>
                Document.fromJson({...currentData!.toJson(), ...arg.toJson()}),
          );
        }
      },
      invalidateQueries: [
        'document/$id',
        'field_suggestions/$id',
        ..._cachedDocumentQueriesToInvalidate,
      ],
    );
  }

  Mutation<Document, DocumentRequest> putDocumentMutation(int id) {
    return Mutation<Document, DocumentRequest>(
      key: 'patch_document/$id',
      mutationFn: (request) {
        return _api.put(id, request);
      },
      onStartMutation: (arg) {
        final query = CachedQuery.instance.getQuery<Query<Document>>(
          'document/$id',
        );
        if (query?.state.data != null) {
          query!.update(
            (currentData) =>
                Document.fromJson({...currentData!.toJson(), ...arg.toJson()}),
          );
        }
      },
      invalidateQueries: [
        'document/$id',
        'field_suggestions/$id',
        ..._cachedDocumentQueriesToInvalidate,
      ],
    );
  }

  Future<String> generateLocalFilePath(
    int documentId, {
    bool original = false,
    PaperlessDirectoryType type = PaperlessDirectoryType.temporary,
  }) async {
    final metadataResult = await getMetaDataQuery(documentId).fetch();
    final documentResult = await getDocumentQuery(documentId).fetch();
    if (documentResult.isError || metadataResult.isError) {
      throw metadataResult.error ?? documentResult.error;
    }

    final metadata = metadataResult.data!;
    final document = documentResult.data!;

    final effectiveFilePath =
        document.archivedFileName ??
        document.originalFileName ??
        metadata.mediaFilename;
    if (effectiveFilePath == null) {
      logger.fe(
        'No valid filename found for document $documentId',
        className: runtimeType.toString(),
        methodName: 'generateLocalFilePath',
      );
      throw Exception('No valid filename found for document $documentId');
    }
    final normalizedPath = effectiveFilePath.replaceAll("/", " ");
    final extension = original ? p.extension(normalizedPath) : '.pdf';
    return "${FileService.instance.getDirectory(type).path}/${p.basenameWithoutExtension(normalizedPath)}$extension";
  }
}
