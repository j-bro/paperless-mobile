import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/patched_tag_request.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/src/models/labels/label_model.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/request/get_filter_options.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/labels_api/label_apis.dart';

class PaperlessTagsApiImpl extends PaperlessTagsApi
    with
        BaseCrudApiImplMixin<
          Tag,
          TagRequest,
          PatchedTagRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/tags/';

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
