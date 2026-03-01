import 'package:dio/dio.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessCorrespondentsApi
    implements
        CrudApi<
          Correspondent,
          CorrespondentRequest,
          PatchedCorrespondentRequest,
          GetFilterOptions
        > {}

abstract class PaperlessTagsApi
    implements CrudApi<Tag, TagRequest, PatchedTagRequest, GetFilterOptions> {}

abstract class PaperlessDocumentTypesApi
    implements
        CrudApi<
          DocumentType,
          DocumentTypeRequest,
          PatchedDocumentTypeRequest,
          GetFilterOptions
        > {}

abstract class PaperlessStoragePathsApi
    implements
        CrudApi<
          StoragePath,
          StoragePathRequest,
          PatchedStoragePathRequest,
          GetFilterOptions
        > {}

class PaperlessTagsApiImpl extends PaperlessTagsApi
    with
        BaseCrudApiImplMixin<
          Tag,
          TagRequest,
          PatchedTagRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/tags';
  @override
  GetFilterOptions defaultFilterOptions = const GetFilterOptions();

  @override
  final Dio client;

  PaperlessTagsApiImpl(this.client);

  @override
  ErrorCode get createErrorCode => ErrorCode.tagCreateFailed;

  @override
  ErrorCode get deleteErrorCode => ErrorCode.tagDeleteFailed;

  @override
  ErrorCode get getErrorCode => ErrorCode.tagLoadFailed;

  @override
  ErrorCode get listErrorCode => ErrorCode.tagLoadFailed;

  @override
  ErrorCode get patchErrorCode => ErrorCode.tagUpdateFailed;

  @override
  ErrorCode get putErrorCode => ErrorCode.tagUpdateFailed;

  @override
  Tag parse(Map<String, dynamic> json) => Tag.fromJson(json);
}

class PaperlessStoragePathsApiImpl extends PaperlessStoragePathsApi
    with
        BaseCrudApiImplMixin<
          StoragePath,
          StoragePathRequest,
          PatchedStoragePathRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/storage_paths';
  @override
  GetFilterOptions defaultFilterOptions = const GetFilterOptions();

  @override
  final Dio client;

  PaperlessStoragePathsApiImpl(this.client);

  @override
  ErrorCode get createErrorCode => ErrorCode.storagePathCreateFailed;

  @override
  ErrorCode get deleteErrorCode => ErrorCode.storagePathDeleteFailed;

  @override
  ErrorCode get getErrorCode => ErrorCode.storagePathLoadFailed;

  @override
  ErrorCode get listErrorCode => ErrorCode.storagePathLoadFailed;

  @override
  ErrorCode get patchErrorCode => ErrorCode.storagePathUpdateFailed;

  @override
  ErrorCode get putErrorCode => ErrorCode.storagePathUpdateFailed;

  @override
  StoragePath parse(Map<String, dynamic> json) => StoragePath.fromJson(json);
}

class PaperlessDocumentTypesApiImpl extends PaperlessDocumentTypesApi
    with
        BaseCrudApiImplMixin<
          DocumentType,
          DocumentTypeRequest,
          PatchedDocumentTypeRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/document_types';
  @override
  GetFilterOptions defaultFilterOptions = const GetFilterOptions();

  @override
  final Dio client;

  PaperlessDocumentTypesApiImpl(this.client);

  @override
  ErrorCode get createErrorCode => ErrorCode.documentTypeCreateFailed;

  @override
  ErrorCode get deleteErrorCode => ErrorCode.documentTypeDeleteFailed;

  @override
  ErrorCode get getErrorCode => ErrorCode.documentTypeLoadFailed;

  @override
  ErrorCode get listErrorCode => ErrorCode.documentTypeLoadFailed;

  @override
  ErrorCode get patchErrorCode => ErrorCode.documentTypeUpdateFailed;

  @override
  ErrorCode get putErrorCode => ErrorCode.documentTypeUpdateFailed;

  @override
  DocumentType parse(Map<String, dynamic> json) => DocumentType.fromJson(json);
}

class PaperlessCorrespondentsApiImpl extends PaperlessCorrespondentsApi
    with
        BaseCrudApiImplMixin<
          Correspondent,
          CorrespondentRequest,
          PatchedCorrespondentRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/correspondents';
  @override
  GetFilterOptions defaultFilterOptions = const GetFilterOptions();

  @override
  final Dio client;

  PaperlessCorrespondentsApiImpl(this.client);

  @override
  ErrorCode get createErrorCode => ErrorCode.correspondentCreateFailed;

  @override
  ErrorCode get deleteErrorCode => ErrorCode.correspondentDeleteFailed;

  @override
  ErrorCode get getErrorCode => ErrorCode.correspondentLoadFailed;

  @override
  ErrorCode get listErrorCode => ErrorCode.correspondentLoadFailed;

  @override
  ErrorCode get patchErrorCode => ErrorCode.correspondentUpdateFailed;

  @override
  ErrorCode get putErrorCode => ErrorCode.correspondentUpdateFailed;

  @override
  Correspondent parse(Map<String, dynamic> json) =>
      Correspondent.fromJson(json);
}
