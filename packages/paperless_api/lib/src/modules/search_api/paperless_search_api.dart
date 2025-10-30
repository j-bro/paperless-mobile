import 'package:paperless_api/generated/lib/src/model/search_result.dart';

abstract interface class PaperlessSearchApi {
  Future<SearchResult> search(String query, {bool? dbOnly});
  Future<Iterable<String>> autocomplete(String term, [int limit = 10]);
}
