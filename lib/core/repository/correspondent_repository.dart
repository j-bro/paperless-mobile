import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_correspondent_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class CorrespondentRepository
    extends
        CrudRepository<
          Correspondent,
          CorrespondentRequest,
          PatchedCorrespondentRequest,
          GetFilterOptions
        > {
  @override
  final PaperlessCorrespondentsApi api;

  CorrespondentRepository(this.api);

  @override
  int extractId(Correspondent item) => item.id;

  @override
  String get queryKey => 'correspondents';
}
