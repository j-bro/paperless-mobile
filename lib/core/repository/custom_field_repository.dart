import 'dart:convert';

import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class CustomFieldsRepository
    extends
        CrudRepository<
          CustomField,
          CustomFieldRequest,
          PatchedCustomFieldRequest,
          GetFilterOptions
        > {
  @override
  final PaperlessCustomFieldsApi api;

  CustomFieldsRepository(this.api);

  @override
  int extractId(CustomField item) => item.id;

  @override
  String get queryKey => 'custom_fields';

  @override
  String? variableHash(GetFilterOptions? options) {
    return jsonEncode(options?.copyWith(page: 1));
  }
}
