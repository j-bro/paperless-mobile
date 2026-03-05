import 'package:dio/dio.dart';
import 'package:paperless_mobile/api/extensions/dio_exception_extension.dart';
import 'package:paperless_mobile/api/models/exception/paperless_api_exception.dart';

Future<T?> getSingleResult<T>(
  String url,
  T Function(Map<String, dynamic>) fromJson,
  ErrorCode errorCode, {
  Map<String, dynamic>? queryParams,
  required Dio client,
}) async {
  try {
    final response = await client.get(
      url,
      queryParameters: removeNullValues(queryParams),
      options: Options(
        headers: {'accept': 'application/json; version=9'},
        validateStatus: (status) => status == 200,
      ),
    );
    return fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (exception) {
    throw exception.unravel(orElse: PaperlessApiException(errorCode));
  }
}

Future<List<T>> getCollection<T>(
  String url,
  T Function(Map<String, dynamic>) fromJson,
  ErrorCode errorCode, {
  Map<String, dynamic>? queryParams,
  required Dio client,
}) async {
  try {
    final response = await client.get(
      url,
      options: Options(
        headers: {'accept': 'application/json; version=9'},
        validateStatus: (status) => status == 200,
        listFormat: ListFormat.csv,
      ),
      queryParameters: queryParams,
    );
    final Map<String, dynamic>? body = response.data;
    if (body == null || body['count'] == 0) {
      return <T>[];
    } else {
      return _collectionFromJson(
        _CollectionFromJsonSerializationParams(
          fromJson,
          body['results'] as List<dynamic>,
        ),
      );
      // return compute(
      //   _collectionFromJson,
      //   _CollectionFromJsonSerializationParams(
      //     fromJson,
      //     (body['results'] ?? []).cast<Map<String, dynamic>>(),
      //   ),
      // );
    }
  } on DioException catch (exception) {
    throw exception.unravel(orElse: PaperlessApiException(errorCode));
  }
}

Map<String, dynamic>? removeNullValues(Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  final cleanedMap = <String, dynamic>{};
  map.forEach((key, value) {
    if (value != null) {
      cleanedMap[key] = value;
    }
  });
  return cleanedMap;
}

List<T> _collectionFromJson<T>(
  _CollectionFromJsonSerializationParams<T> params,
) {
  return params.list.map<T>((result) => params.fromJson(result)).toList();
}

class _CollectionFromJsonSerializationParams<T> {
  final T Function(Map<String, dynamic>) fromJson;
  final List<dynamic> list;

  _CollectionFromJsonSerializationParams(this.fromJson, this.list);
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

int? tryParseNullable(String? source, {int? radix}) {
  if (source == null) return null;
  return int.tryParse(source, radix: radix);
}
