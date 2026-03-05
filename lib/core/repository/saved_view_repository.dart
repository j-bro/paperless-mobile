import 'dart:convert';

import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class SavedViewRepository
    extends
        CrudRepository<
          SavedView,
          SavedViewRequest,
          PatchedSavedViewRequest,
          GetFilterOptions
        > {
  @override
  final PaperlessSavedViewsApi api;

  SavedViewRepository(this.api);

  @override
  int extractId(SavedView item) => item.id;

  @override
  String get queryKey => 'saved_views';

  @override
  String? variableHash(GetFilterOptions? options) {
    return jsonEncode(options?.copyWith(page: 1));
  }
}
