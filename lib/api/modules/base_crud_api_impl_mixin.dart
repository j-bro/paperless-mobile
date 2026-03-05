import 'package:dio/dio.dart';
import 'package:paperless_mobile/api/extensions/dio_exception_extension.dart';
import 'package:paperless_mobile/api/models/models.dart';
import 'package:paperless_mobile/api/modules/crud_api.dart';
import 'package:paperless_mobile/api/utils/request_utils.dart';
import 'package:paperless_mobile/api/utils/unsafe_to_json.dart';

///
/// Mixin providing a default implementation for most CRUD API endpoints.
///
mixin BaseCrudApiImplMixin<Model, Request, PatchedRequest, FilterOptions>
    on CrudApi<Model, Request, PatchedRequest, FilterOptions> {
  Dio get client;

  FilterOptions get defaultFilterOptions;
  String get path;

  Model parse(Map<String, dynamic> json);

  ErrorCode get createErrorCode;
  ErrorCode get deleteErrorCode;
  ErrorCode get getErrorCode;
  ErrorCode get listErrorCode;
  ErrorCode get patchErrorCode;
  ErrorCode get putErrorCode;

  @override
  Future<Model> create(Request item) async {
    try {
      final response = await client.post(
        '$path/',
        data: unsafeToJson(item),
        options: Options(validateStatus: (status) => status == 201),
      );
      return parse(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(orElse: PaperlessApiException(createErrorCode));
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      await client.delete(
        "$path/$id/",
        options: Options(validateStatus: (status) => status == 204),
      );
      return id;
    } on DioException catch (exception) {
      throw exception.unravel(orElse: PaperlessApiException(deleteErrorCode));
    }
  }

  @override
  Future<Model?> get(int id) {
    return getSingleResult(
      '$path/$id/',
      parse,
      getErrorCode,
      client: client,
      queryParams: removeNullValues({'full_perms': true}),
    );
  }

  @override
  Future<List<Model>> getAll([FilterOptions? options]) {
    return getCollection(
      '$path/',
      parse,
      listErrorCode,
      client: client,
      queryParams: removeNullValues(
        unsafeToJson(options ?? defaultFilterOptions),
      ),
    );
  }

  @override
  Future<Model> patch(int id, PatchedRequest item) async {
    try {
      final response = await client.patch(
        "$path/$id/",
        data: unsafeToJson(item),
        options: Options(validateStatus: (status) => status == 200),
      );
      return parse(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(orElse: PaperlessApiException(patchErrorCode));
    }
  }

  @override
  Future<Model> put(int id, Request item) async {
    try {
      final response = await client.put(
        "$path/$id/",
        data: unsafeToJson(item),
        options: Options(validateStatus: (status) => status == 200),
      );
      return parse(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(orElse: PaperlessApiException(putErrorCode));
    }
  }
}
