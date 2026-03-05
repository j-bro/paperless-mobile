import 'dart:convert';

import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class StoragePathRepository
    extends
        CrudRepository<
          StoragePath,
          StoragePathRequest,
          PatchedStoragePathRequest,
          GetFilterOptions
        > {
  @override
  final PaperlessStoragePathsApi api;

  StoragePathRepository(this.api);

  @override
  int extractId(StoragePath item) => item.id;

  @override
  String get queryKey => 'storage_paths';

  @override
  String? variableHash(GetFilterOptions? options) {
    final normalized = options?.copyWith(page: null).toJson()?..remove('page');
    return jsonEncode(normalized);
  }
}
