import 'package:paperless_api/generated/lib/src/model/custom_field.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_custom_field_request.dart';
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
    return options?.copyWith(page: 1).hashCode.toString();
  }
}
