import 'package:dio/dio.dart';
import 'package:paperless_mobile/api/models/custom_field.dart';
import 'package:paperless_mobile/api/models/custom_field_request.dart';
import 'package:paperless_mobile/api/models/patched_custom_field_request.dart';
import 'package:paperless_mobile/api/models/models.dart';
import 'package:paperless_mobile/api/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_mobile/api/modules/crud_api.dart';

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
  GetFilterOptions defaultFilterOptions = const GetFilterOptions();

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
