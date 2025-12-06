import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

class SearchRepository {
  final PaperlessSearchApi _searchApi;

  SearchRepository(this._searchApi);

  Query<SearchResult> searchQuery(String query, {bool? dbOnly}) {
    final queryKey = 'search/$query/${dbOnly ?? 'null'}';
    return Query(
      key: queryKey,
      queryFn: () => _searchApi.search(query, dbOnly: dbOnly),
    );
  }

  Query<Iterable<String>> autocompleteQuery(String term, [int limit = 10]) {
    final queryKey = 'search-autocomplete/$term/$limit';
    return Query(
      key: queryKey,
      queryFn: () => _searchApi.autocomplete(term, limit),
    );
  }
}
