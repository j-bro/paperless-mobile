import 'dart:convert';

import 'package:paperless_mobile/api/paperless_api.dart';
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

  @override
  String? variableHash(GetFilterOptions? options) {
    final normalized = options?.toJson()?..remove('page');
    return jsonEncode(normalized);
  }
}
