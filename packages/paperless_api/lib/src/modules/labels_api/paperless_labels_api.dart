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
  Future<List<Correspondent>> getCorrespondents(LabelGetOptions? options);
  Future<Correspondent> createCorrespondent(LabelRequest correspondent);
  Future<Correspondent> putCorrespondent(LabelRequest correspondent);
  Future<Correspondent> patchCorrespondent(LabelPatchRequest correspondent);
  Future<int> deleteCorrespondent(int id);

  Future<Tag?> getTag(int id, {bool? fullPermissions});
  Future<List<Tag>> getTags(LabelGetOptions? options);
  Future<Tag> createTag(TagRequest tag);
  Future<Tag> putTag(TagRequest tag);
  Future<Tag> patchTag(TagPatchRequest tag);
  Future<int> deleteTag(int id);

  Future<DocumentType?> getDocumentType(int id, {bool? fullPermissions});
  Future<List<DocumentType>> getDocumentTypes(LabelGetOptions? options);
  Future<DocumentType> createDocumentType(LabelRequest type);
  Future<DocumentType> putDocumentType(LabelRequest documentType);
  Future<DocumentType> patchDocumentType(LabelPatchRequest documentType);
  Future<int> deleteDocumentType(int id);

  Future<StoragePath?> getStoragePath(int id, {bool? fullPermissions});
  Future<List<StoragePath>> getStoragePaths(LabelGetOptions? options);
  Future<StoragePath> createStoragePath(StoragePathRequest storagePath);
  Future<StoragePath> putStoragePath(StoragePathRequest storagePath);
  Future<StoragePath> patchStoragePath(StoragePathPatchRequest storagePath);
  Future<int> deleteStoragePath(int id);
}
