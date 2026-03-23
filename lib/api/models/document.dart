import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/custom_field_instance.dart';
import 'package:paperless_mobile/api/models/document_permissions.dart';
import 'package:paperless_mobile/api/models/note.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class Document with _$Document {
  factory Document({
    required int id,
    required int? correspondent,
    required int? documentType,
    required int? storagePath,
    String? title,

    /// The raw, text-only data of the document. This field is primarily used for searching.
    String? content,
    required List<int> tags,
    DateTime? created,
    @Deprecated('createdDate has been deprecated') DateTime? createdDate,
    required DateTime modified,
    required DateTime added,
    DateTime? deletedAt,

    /// The position of this document in your physical document archive.
    // minimum: 0
    // maximum: 4294967295
    int? archiveSerialNumber,
    required String? originalFileName,
    required String? archivedFileName,
    int? owner,
    DocumentPermissions? permissions,
    bool? userCanChange,
    bool? isSharedByRequester,
    required List<Note> notes,
    @Default([]) List<CustomFieldInstance>? customFields,
    required int? pageCount,
    required String mimeType,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}
