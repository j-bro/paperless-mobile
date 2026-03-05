import 'dart:convert';

import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class TagRepository
    extends
        CrudRepository<Tag, TagRequest, PatchedTagRequest, GetFilterOptions> {
  @override
  final PaperlessTagsApi api;

  TagRepository(this.api);

  @override
  int extractId(Tag item) => item.id;

  @override
  String get queryKey => 'tags';

  @override
  String? variableHash(GetFilterOptions? options) {
    final normalized = options?.copyWith(page: null).props;
    return jsonEncode(normalized);
  }
}
