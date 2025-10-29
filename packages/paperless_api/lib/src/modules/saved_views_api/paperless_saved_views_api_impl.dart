import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/patched_saved_view_request.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';

class PaperlessSavedViewsApiImpl extends PaperlessSavedViewsApi
    with
        BaseCrudApiImplMixin<
          SavedView,
          SavedViewRequest,
          PatchedSavedViewRequest,
          GetFilterOptions
        > {
  @override
  final Dio client;

  PaperlessSavedViewsApiImpl(this.client);

  @override
  String get path => "/api/saved_views/";
  @override
  SavedView parse(Map<String, dynamic> json) => SavedView.fromJson(json);
  @override
  Map<String, dynamic> requestToJson(SavedViewRequest request) =>
      request.toJson();
  @override
  Map<String, dynamic> patchedRequestToJson(PatchedSavedViewRequest request) =>
      request.toJson();
  @override
  Map<String, dynamic>? filterOptionsToJson(GetFilterOptions? options) =>
      options?.toJson();
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
