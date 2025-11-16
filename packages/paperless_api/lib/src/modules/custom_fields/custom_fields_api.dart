import 'package:paperless_api/generated/lib/src/model/custom_field.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_custom_field_request.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessCustomFieldsApi
    implements
        CrudApi<
          CustomField,
          CustomFieldRequest,
          PatchedCustomFieldRequest,
          GetFilterOptions
        > {}
