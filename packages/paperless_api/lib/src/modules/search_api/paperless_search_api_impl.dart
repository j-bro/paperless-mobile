import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/search_result.dart';
import 'package:paperless_api/src/modules/search_api/paperless_search_api.dart';

class PaperlessSearchApiImpl implements PaperlessSearchApi {
  final Dio _client;

  PaperlessSearchApiImpl(this._client);

  @override
  Future<Iterable<String>> autocomplete(String term, [int limit = 10]) {
    return _client
        .get<List<dynamic>>(
          '/api/search/autocomplete/',
          queryParameters: {'term': term, 'limit': limit},
        )
        .then((response) => response.data!.cast<String>());
  }

  @override
  Future<SearchResult> search(String query, {bool? dbOnly}) {
    return _client
        .get<Map<String, dynamic>>(
          '/api/search/',
          queryParameters: {
            'query': query,
            if (dbOnly != null) 'db_only': dbOnly,
          },
        )
        .then((response) => SearchResult.fromJson(response.data!));
  }
}
