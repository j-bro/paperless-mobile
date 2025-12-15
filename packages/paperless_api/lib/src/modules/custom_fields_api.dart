import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_custom_field_request.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessCustomFieldsApi
    implements
        CrudApi<
          CustomField,
          CustomFieldRequest,
          PatchedCustomFieldRequest,
          GetFilterOptions
        > {}

class PaperlessCustomFieldsApiImpl extends PaperlessCustomFieldsApi
    with
        BaseCrudApiImplMixin<
          CustomField,
          CustomFieldRequest,
          PatchedCustomFieldRequest,
          GetFilterOptions
        > {
  @override
  final Dio client;

  PaperlessCustomFieldsApiImpl(this.client);

  @override
  String get path => "/api/custom_fields";
  @override
  CustomField parse(Map<String, dynamic> json) => CustomField.fromJson(json);

  @override
  ErrorCode get createErrorCode => ErrorCode.customFieldCreateFailed;
  @override
  ErrorCode get deleteErrorCode => ErrorCode.customFieldDeleteFailed;
  @override
  ErrorCode get getErrorCode => ErrorCode.customFieldLoadFailed;
  @override
  ErrorCode get listErrorCode => ErrorCode.customFieldLoadFailed;
  @override
  ErrorCode get patchErrorCode => ErrorCode.customFieldUpdateFailed;
  @override
  ErrorCode get putErrorCode => ErrorCode.customFieldUpdateFailed;
}
