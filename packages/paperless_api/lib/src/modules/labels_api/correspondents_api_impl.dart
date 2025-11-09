import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_correspondent_request.dart';
import 'package:paperless_api/src/models/labels/label_model.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/request/get_filter_options.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/labels_api/label_apis.dart';

class PaperlessCorrespondentsApiImpl extends PaperlessCorrespondentsApi
    with
        BaseCrudApiImplMixin<
          Correspondent,
          CorrespondentRequest,
          PatchedCorrespondentRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/correspondents/';

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
