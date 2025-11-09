import 'package:paperless_api/generated/lib/src/model/patched_storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_request.dart';
import 'package:paperless_api/paperless_api.dart';
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
}
