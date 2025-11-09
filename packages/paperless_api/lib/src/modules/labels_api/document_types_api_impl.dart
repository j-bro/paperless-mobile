import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_type_request.dart';
import 'package:paperless_api/src/models/labels/label_model.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/request/get_filter_options.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/labels_api/label_apis.dart';

class PaperlessDocumentTypesApiImpl extends PaperlessDocumentTypesApi
    with
        BaseCrudApiImplMixin<
          DocumentType,
          DocumentTypeRequest,
          PatchedDocumentTypeRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/document_types/';

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
