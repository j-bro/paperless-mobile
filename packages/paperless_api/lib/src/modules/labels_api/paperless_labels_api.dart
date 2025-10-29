import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_correspondent_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_document_type_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/patched_tag_request.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_request.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/src/models/models.dart';

///
/// Provides basic CRUD operations for labels, including:
/// <ul>
///    <li>Correspondents</li>
///    <li>Document Types</li>
///    <li>Tags</li>
///    <li>Storage Paths</li>
/// </ul>
///
abstract class PaperlessLabelsApi {
  Future<Correspondent?> getCorrespondent(int id, {bool? fullPermissions});
  Future<List<Correspondent>> getCorrespondents(GetFilterOptions? options);
  Future<Correspondent> createCorrespondent(CorrespondentRequest correspondent);
  Future<Correspondent> putCorrespondent(
    int id,
    CorrespondentRequest correspondent,
  );
  Future<Correspondent> patchCorrespondent(
    int id,
    PatchedCorrespondentRequest correspondent,
  );
  Future<int> deleteCorrespondent(int id);

  Future<Tag?> getTag(int id, {bool? fullPermissions});
  Future<List<Tag>> getTags(GetFilterOptions? options);
  Future<Tag> createTag(TagRequest tag);
  Future<Tag> putTag(int id, TagRequest tag);
  Future<Tag> patchTag(int id, PatchedTagRequest tag);
  Future<int> deleteTag(int id);

  Future<DocumentType?> getDocumentType(int id, {bool? fullPermissions});
  Future<List<DocumentType>> getDocumentTypes(GetFilterOptions? options);
  Future<DocumentType> createDocumentType(DocumentTypeRequest type);
  Future<DocumentType> putDocumentType(
    int id,
    DocumentTypeRequest documentType,
  );
  Future<DocumentType> patchDocumentType(
    int id,
    PatchedDocumentTypeRequest documentType,
  );
  Future<int> deleteDocumentType(int id);

  Future<StoragePath?> getStoragePath(int id, {bool? fullPermissions});
  Future<List<StoragePath>> getStoragePaths(GetFilterOptions? options);
  Future<StoragePath> createStoragePath(StoragePathRequest storagePath);
  Future<StoragePath> putStoragePath(int id, StoragePathRequest storagePath);
  Future<StoragePath> patchStoragePath(
    int id,
    PatchedStoragePathRequest storagePath,
  );
  Future<int> deleteStoragePath(int id);
}
