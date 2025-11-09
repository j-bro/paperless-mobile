import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/patched_storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_request.dart';
import 'package:paperless_api/src/models/labels/label_model.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/request/get_filter_options.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';
import 'package:paperless_api/src/modules/labels_api/label_apis.dart';

class PaperlessStoragePathsApiImpl extends PaperlessStoragePathsApi
    with
        BaseCrudApiImplMixin<
          StoragePath,
          StoragePathRequest,
          PatchedStoragePathRequest,
          GetFilterOptions
        > {
  @override
  String get path => '/api/storage_paths/';

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
