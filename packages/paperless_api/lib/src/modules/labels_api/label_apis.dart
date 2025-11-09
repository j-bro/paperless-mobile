import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_tag_request.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/src/models/models.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessCorrespondentsApi
    implements
        CrudApi<
          Correspondent,
          CorrespondentRequest,
          PatchedCorrespondentRequest,
          GetFilterOptions
        > {}

abstract class PaperlessTagsApi
    implements CrudApi<Tag, TagRequest, PatchedTagRequest, GetFilterOptions> {}

abstract class PaperlessDocumentTypesApi
    implements
        CrudApi<
          DocumentType,
          DocumentTypeRequest,
          PatchedDocumentTypeRequest,
          GetFilterOptions
        > {}

abstract class PaperlessStoragePathsApi
    implements
        CrudApi<
          StoragePath,
          StoragePathRequest,
          PatchedStoragePathRequest,
          GetFilterOptions
        > {}
