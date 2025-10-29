import 'package:dio/dio.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/crud_api.dart';
import 'package:paperless_api/src/request_utils.dart';

///
/// Mixin providing a default implementation for most CRUD API endpoints.
///
mixin BaseCrudApiImplMixin<Model, Request, PatchedRequest, FilterOptions>
    on CrudApi<Model, Request, PatchedRequest, FilterOptions> {
  Dio get client;

  String get path;
  Model parse(Map<String, dynamic> json);
  Map<String, dynamic> requestToJson(Request request);
  Map<String, dynamic> patchedRequestToJson(PatchedRequest request);
  Map<String, dynamic>? filterOptionsToJson(FilterOptions? options);
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
        path,
        data: requestToJson(item),
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
  Future<Model?> get(int id, {bool? fullPerms}) {
    return getSingleResult(
      '$path/$id/',
      parse,
      getErrorCode,
      client: client,
      queryParams: removeNullValues({'full_perms': fullPerms}),
    );
  }

  @override
  Future<List<Model>> getAll([FilterOptions? options]) {
    return getCollection(
      path,
      parse,
      listErrorCode,
      client: client,
      queryParams: removeNullValues(filterOptionsToJson(options)),
    );
  }

  @override
  Future<Model> patch(int id, PatchedRequest item) async {
    try {
      final response = await client.patch(
        "$path/$id/",
        data: patchedRequestToJson(item),
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
        data: requestToJson(item),
        options: Options(validateStatus: (status) => status == 200),
      );
      return parse(response.data);
    } on DioException catch (exception) {
      throw exception.unravel(orElse: PaperlessApiException(putErrorCode));
    }
  }
}
