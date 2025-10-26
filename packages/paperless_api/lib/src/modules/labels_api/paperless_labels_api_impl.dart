import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/labels_api/paperless_labels_api.dart';
import 'package:paperless_api/src/request_utils.dart';

//Notes:
// Removed content type json header
class PaperlessLabelApiImpl implements PaperlessLabelsApi {
  final Dio _client;

  PaperlessLabelApiImpl(this._client);
  @override
  Future<Correspondent?> getCorrespondent(
    int id, {
    bool? fullPermissions,
  }) async {
    return getSingleResult(
      "/api/correspondents/$id/",
      Correspondent.fromJson,
      ErrorCode.correspondentLoadFailed,
      client: _client,
    );
  }

  @override
  Future<DocumentType?> getDocumentType(int id, {bool? fullPermissions}) async {
    return getSingleResult(
      "/api/document_types/$id/",
      DocumentType.fromJson,
      ErrorCode.documentTypeLoadFailed,
      client: _client,
      queryParams: removeNullValues({"full_perms": fullPermissions}),
    );
  }

  @override
  Future<StoragePath?> getStoragePath(int id, {bool? fullPermissions}) {
    return getSingleResult(
      "/api/storage_paths/$id/",
      StoragePath.fromJson,
      ErrorCode.storagePathLoadFailed,
      queryParams: removeNullValues({'full_perms': fullPermissions}),
      client: _client,
    );
  }

  @override
  Future<Tag?> getTag(int id, {bool? fullPermissions}) async {
    return getSingleResult(
      "/api/tags/$id/",
      Tag.fromJson,
      ErrorCode.tagLoadFailed,
      client: _client,
      queryParams: removeNullValues({"full_perms": fullPermissions}),
    );
  }

  @override
  Future<List<Correspondent>> getCorrespondents(
    LabelGetOptions? options,
  ) async {
    final results = await getCollection(
      "/api/correspondents/",
      Correspondent.fromJson,
      ErrorCode.correspondentLoadFailed,
      queryParams: removeNullValues(options?.toJson()),
      client: _client,
    );

    return results;
  }

  @override
  Future<List<DocumentType>> getDocumentTypes(LabelGetOptions? options) async {
    final results = await getCollection(
      "/api/document_types/?page=1&page_size=100000",
      DocumentType.fromJson,
      ErrorCode.documentTypeLoadFailed,
      queryParams: removeNullValues(options?.toJson()),
      client: _client,
    );

    return results;
  }

  @override
  Future<List<Tag>> getTags(LabelGetOptions? options) async {
    final results = await getCollection(
      "/api/tags/",
      Tag.fromJson,
      ErrorCode.tagLoadFailed,
      queryParams: options?.toJson(),
      client: _client,
    );
    return results;
  }

  @override
  Future<List<StoragePath>> getStoragePaths(LabelGetOptions? options) async {
    final results = await getCollection(
      "/api/storage_paths/?page=1&page_size=100000",
      StoragePath.fromJson,
      ErrorCode.storagePathLoadFailed,
      client: _client,
      queryParams: options?.toJson(),
    );

    return results;
  }

  @override
  Future<Correspondent> createCorrespondent(LabelRequest correspondent) async {
    try {
      final response = await _client.post(
        '/api/correspondents/',
        data: correspondent.toJson(),
        options: Options(validateStatus: (status) => status == 201),
      );
      return Correspondent.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.correspondentCreateFailed,
        ),
      );
    }
  }

  @override
  Future<DocumentType> createDocumentType(LabelRequest documentType) async {
    try {
      final response = await _client.post(
        '/api/document_types/',
        data: documentType.toJson(),
        options: Options(validateStatus: (status) => status == 201),
      );
      return DocumentType.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentTypeCreateFailed),
      );
    }
  }

  @override
  Future<Tag> createTag(TagRequest tag) async {
    try {
      final response = await _client.post(
        '/api/tags/',
        data: tag.toJson(),
        options: Options(
          headers: {"Accept": "application/json; version=2"},
          validateStatus: (status) => status == 201,
        ),
      );
      return Tag.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.tagCreateFailed),
      );
    }
  }

  @override
  Future<int> deleteCorrespondent(int id) async {
    try {
      await _client.delete(
        '/api/correspondents/$id/',
        options: Options(validateStatus: (status) => status == 204),
      );
      return id;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.correspondentDeleteFailed,
        ),
      );
    }
  }

  @override
  Future<int> deleteDocumentType(int id) async {
    try {
      await _client.delete(
        '/api/document_types/$id/',
        options: Options(validateStatus: (status) => status == 204),
      );
      return id;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentTypeDeleteFailed),
      );
    }
  }

  @override
  Future<int> deleteTag(int id) async {
    try {
      await _client.delete(
        '/api/tags/$id/',
        options: Options(validateStatus: (status) => status == 204),
      );
      return id;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.tagDeleteFailed),
      );
    }
  }

  @override
  Future<int> deleteStoragePath(int id) async {
    try {
      await _client.delete(
        '/api/storage_paths/$id/',
        options: Options(validateStatus: (status) => status == 204),
      );
      return id;
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.storagePathDeleteFailed),
      );
    }
  }

  @override
  Future<Correspondent> putCorrespondent(LabelRequest correspondent) async {
    try {
      final response = await _client.put(
        '/api/correspondents/${correspondent.id}/',
        data: correspondent.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return Correspondent.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.correspondentUpdateFailed,
        ),
      );
    }
  }

  @override
  Future<Correspondent> patchCorrespondent(
    LabelPatchRequest correspondent,
  ) async {
    try {
      final response = await _client.patch(
        '/api/correspondents/${correspondent.id}/',
        data: json.encode(correspondent.toJson()),
        options: Options(validateStatus: (status) => status == 200),
      );
      return Correspondent.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.correspondentUpdateFailed,
        ),
      );
    }
  }

  @override
  Future<DocumentType> putDocumentType(LabelRequest documentType) async {
    try {
      final response = await _client.put(
        '/api/document_types/${documentType.id}/',
        data: documentType.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return DocumentType.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentTypeUpdateFailed),
      );
    }
  }

  @override
  Future<DocumentType> patchDocumentType(LabelPatchRequest documentType) async {
    try {
      final response = await _client.patch(
        '/api/document_types/${documentType.id}/',
        data: documentType.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return DocumentType.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.documentTypeUpdateFailed),
      );
    }
  }

  @override
  Future<Tag> putTag(TagRequest tag) async {
    try {
      final response = await _client.put(
        '/api/tags/${tag.id}/',
        options: Options(
          headers: {"Accept": "application/json; version=2"},
          validateStatus: (status) => status == 200,
        ),
        data: tag.toJson(),
      );
      return Tag.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.tagUpdateFailed),
      );
    }
  }

  @override
  Future<Tag> patchTag(TagPatchRequest tag) async {
    try {
      final response = await _client.patch(
        '/api/tags/${tag.id}/',
        options: Options(
          headers: {"Accept": "application/json; version=2"},
          validateStatus: (status) => status == 200,
        ),
        data: tag.toJson(),
      );
      return Tag.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.tagUpdateFailed),
      );
    }
  }

  @override
  Future<StoragePath> createStoragePath(LabelRequest storagePath) async {
    try {
      final response = await _client.post(
        '/api/storage_paths/',
        data: storagePath.toJson(),
        options: Options(validateStatus: (status) => status == 201),
      );
      return StoragePath.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.storagePathCreateFailed),
      );
    }
  }

  @override
  Future<StoragePath> putStoragePath(LabelRequest path) async {
    try {
      final response = await _client.put(
        '/api/storage_paths/${path.id}/',
        data: path.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return StoragePath.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.storagePathUpdateFailed),
      );
    }
  }

  @override
  Future<StoragePath> patchStoragePath(
    StoragePathPatchRequest storagePath,
  ) async {
    try {
      final response = await _client.patch(
        '/api/storage_paths/${storagePath.id}/',
        data: storagePath.toJson(),
        options: Options(validateStatus: (status) => status == 200),
      );
      return StoragePath.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(ErrorCode.storagePathUpdateFailed),
      );
    }
  }
}
