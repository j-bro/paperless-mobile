import 'package:paperless_api/generated/lib/src/model/document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_type_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class DocumentTypeRepository
    extends
        CrudRepository<
          DocumentType,
          DocumentTypeRequest,
          PatchedDocumentTypeRequest,
          GetFilterOptions
        > {
  @override
  final PaperlessDocumentTypesApi api;

  DocumentTypeRepository(this.api);

  @override
  int extractId(DocumentType item) => item.id;

  @override
  String get queryKey => 'document_types';

  @override
  String? variableHash(GetFilterOptions? options) {
    final normalized = options?.toJson()?..remove('page');
    return normalized.hashCode.toString();
  }
}
