import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/patched_saved_view_request.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_request.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessSavedViewsApi
    extends
        CrudApi<
          SavedView,
          SavedViewRequest,
          PatchedSavedViewRequest,
          GetFilterOptions
        > {}

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
  String get path => "/api/saved_views";
  @override
  SavedView parse(Map<String, dynamic> json) => SavedView.fromJson(json);

  @override
  ErrorCode get createErrorCode => ErrorCode.createSavedViewError;
  @override
  ErrorCode get deleteErrorCode => ErrorCode.deleteSavedViewError;
  @override
  ErrorCode get getErrorCode => ErrorCode.loadSavedViewsError;
  @override
  ErrorCode get listErrorCode => ErrorCode.loadSavedViewsError;
  @override
  ErrorCode get patchErrorCode => ErrorCode.updateSavedViewError;
  @override
  ErrorCode get putErrorCode => ErrorCode.updateSavedViewError;
}
